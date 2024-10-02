#!/bin/bash
# Default values
LANGUAGE="en"
SPEAKER="default"
FORCE=0
MUTE=0
SERVER="localhost:8020"
# Dynamically determine the script's directory and set SERVER_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$SCRIPT_DIR/xtts_api_server/speakers"

# Parse options for language (-l), speaker (-s), force overwrite (-f), list languages (-L), list speakers (-S), and mute (-m)
while getopts "l:s:fLSm" opt; do
  case $opt in
    l) LANGUAGE="$OPTARG" ;;
    s) SPEAKER="$OPTARG" ;;
    f) FORCE=1 ;;
    L) list_languages; exit 0 ;;
    S) list_speakers; exit 0 ;;
    m) MUTE=1 ;;  # Set mute flag when -m is used
    *) show_usage ;;
  esac
done

# Remove the path from the speaker name when it is used to only keep the end SPEAKER "fr/example" -> "example"
SPEAKER_FOLDER="${SPEAKER##*/}"

# EDIT THAT AS YOU WISH
BASE_DIR="$HOME/Audio/Bjornulf/$LANGUAGE/$SPEAKER_FOLDER"

# Function to show usage menu
show_usage() {
  echo "Usage: $0 [-l language] [-s speaker] [-f] [-L] [-S] [-m] <text>"
  echo ""
  echo "Options:"
  echo "  -l language    Set the language (default: en)"
  echo "  -s speaker     Set the speaker (default: default)"
  echo "  -f             Force overwrite of existing audio file (Use if audio is not good enough, it will try another generation)"
  echo "  -L             List available languages"
  echo "  -S             List available speakers"
  echo "  -m             Mute audio playback (download only, don't play the audio)"
  echo "  <text>         The text to convert to speech"
  echo ""
  echo Example:
  echo "  $0 -l en -s default -m \"Hello, world\""
  exit 1
}

# Function to list available languages
list_languages() {
  curl -s http://$SERVER/languages | jq -r '.languages | to_entries[] | "\(.key): \(.value)"'
}

# Simplified function to list all available speakers across all languages
list_speakers() {
  echo "Available speakers:"
  cd $SERVER_DIR && find "./" -type f -name "*.wav" | sed 's|./||' | sed 's|\.wav$||' && cd -
}

# Function to sanitize text like in the Python example
sanitize_text() {
  echo "$1" | sed 's/[^a-zA-Z0-9 _-]//g' | tr ' ' '_' | cut -c1-100 # Limit to 100 characters, it's 50 for now on Bjornulf lobe chat...
}

# Shift the options to get the text argument
shift $((OPTIND - 1))

# Check if text is provided
if [ -z "$1" ]; then
  show_usage
fi

# Adjust language code if needed
if [ "$LANGUAGE" = "cn" ]; then
  LANGUAGE="zh-cn"
fi

TEXT="$*"
echo "Encoded TEXT: $TEXT"

# Sanitize the text to create a valid filename
FILENAME="$(sanitize_text "$TEXT").mp3"

# Full path to the audio file
AUDIO_PATH="$BASE_DIR/$FILENAME"

echo "Sanitized filename: $FILENAME"
echo "Full audio path: $AUDIO_PATH"

# URL encoding for the text
# TEXT="${TEXT// /%20}"

# URL for the TTS API with language and speaker options
URL="http://$SERVER/tts_stream?language=$LANGUAGE&speaker_wav=$SPEAKER&text=$TEXT"
echo "URL: $URL"

# Create the directory for saving the audio
mkdir -p "$BASE_DIR"

# If the file exists and force is not enabled, skip downloading
if [ -f "$AUDIO_PATH" ] && [ $FORCE -eq 0 ]; then
  echo "Audio file already exists: $AUDIO_PATH. Use -f to overwrite."
else
  if [ $FORCE -eq 1 ]; then
    echo "Forcing overwrite of existing file: $AUDIO_PATH"
  fi
  echo "Downloading and saving audio to: $AUDIO_PATH"
  # curl -s "$URL" -o "$AUDIO_PATH"
  wget -q "$URL" -O "$AUDIO_PATH"
fi
echo

# Play the audio using ffplay, fallback to mplayer if ffplay is unavailable
if [ $MUTE -eq 0 ]; then  # Only play if mute is not enabled
  if command -v ffplay >/dev/null 2>&1; then
    ffplay -autoexit -nodisp "$AUDIO_PATH"
  elif command -v mplayer >/dev/null 2>&1; then
    mplayer "$AUDIO_PATH"
  else
    echo "No suitable audio player found (ffplay or mplayer)."
  fi
else
  echo "Audio playback is muted."
fi
