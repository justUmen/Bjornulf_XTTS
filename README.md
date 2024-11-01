# 🔊 Bjornulf Text To Speech v0.3 🔊

My custom Text To Speech API server.  

After install and launch, you can use my TTS server in multiple ways :    
1 - 🗔 In Linux command line, with the included script : `bjornulf_tts.sh`  
2 - 💬 In my AI bot chat : [Bjornulf Lobe Chat Fork](https://github.com/justUmen/Bjornulf_lobe-chat)  
3 - 🎨 Inside Comfyui with my custom node TTS number 31 : [Bjornulf Comfyui TTS node](https://github.com/justUmen/ComfyUI-BjornulfNodes?tab=readme-ov-file#31----tts---text-to-speech-100-local-any-voice-you-want-any-language)  

# Coffee : ☕☕☕☕☕ 5/5

❤️❤️❤️ <https://ko-fi.com/bjornulf> ❤️❤️❤️

# ☘ This project is part of my AI trio. ☘

1 - 📝 Text/Chat AI generation : [Bjornulf Lobe Chat Fork](https://github.com/justUmen/Bjornulf_lobe-chat)  
<u>**2 - 🔊 Speech AI generation** : [Bjornulf Text To Speech](https://github.com/justUmen/Bjornulf_XTTS) (you are here)</u>   
3 - 🎨 Image AI generation : [Bjornulf Comfyui custom nodes](https://github.com/justUmen/Bjornulf_custom_nodes)  

## Installation of the server (Tested with python v3.11.9)

Recommended : create virtual environment and activate it.

```
python3 -m venv ~/venv/xtts2
source ~/venv/xtts2/bin/activate
```

Choose location of course before cloning.  

```
git clone https://github.com/justUmen/Bjornulf_XTTS/
cd Bjornulf_XTTS
pip install -r requirements.txt
cd xtts_api_server
python bjornulf_xtts_server.py
```

### How to I personnaly use it ? (icon)

I use a .desktop file to launch the server, with a custom icon.

Here is mine, change it as needed :

```
[Desktop Entry]
Name=xtts_server
Comment=xtts_server
Exec=kitty --class "kitty_xtts" --title "kitty - xtts" zsh -i -c 'source /home/umen/venv/xtts/bin/activate && cd /home/umen/SyNc/Forks/Bjornulf_XTTS/xtts_api_server/ && systemd-inhibit --what=sleep --who="bjornulf app" --why="Preventing sleep to complete the task" --mode=block python bjornulf_xtts_server.py || read'
Icon=/home/umen/SyNc/Conf/desktop_applications/icons/speaker.svg
Terminal=false
Type=Application
Categories=Utility;
StartupWMClass=kitty_xtts
```

Note that i use kitty terminal and a systemd-inhibit to prevent sleep while the server is running. (You can simplify all that if you want)  
Of course put your own paths -> where is located your bjornulf_xtts_server, your icon, your virtual environment, etc...  
I also use a custom class "kitty_xtts" to manage it in my window manager. (In my case just to keep it in a specific workspace.)  
To open the server i just click on this icon.  
To close the server, i just go on the kitty window terminal and CTRL + C inside.  

## How to add a voice ?

Just put a voice sample .wav file in the `xtts_api_server/speakers` folder. (I recommend creating a subfolder for each language. like `en`, `fr`, etc...)  

Here you can download a sample with `Attenborough` voice (English so put in a folder `en`) : <https://drive.google.com/file/d/1JOSpavgN0GS2OswXbQCpqL5kYV0nSr6n/view?usp=sharing>  

Note : You can actually use an english sample to speak another language. (Not ideal but you can try it out.)  

## 🗔 Linux Command line usage (`bjornulf_tts.sh`) :

```
Usage: /home/umen/SyNc/Forks/Bjornulf_XTTS/bjornulf_tts.sh [-l language] [-s speaker] [-f] [-L] [-S] [-m] <text>

Options:
  -l language    Set the language (default: en)
  -s speaker     Set the speaker (default: default)
  -f             Force overwrite of existing audio file (Use if audio is not good enough, it will try another generation)
  -L             List available languages
  -S             List available speakers
  -m             Mute audio playback (download only, don't play the audio)
  <text>         The text to convert to speech

Example:
  ./bjornulf_tts.sh -l en -s fr/une_voix "Bonjour tout le monde."
```

This script will generate a .mp3 file in the path provided in the script, edit if you want to change it : `BASE_DIR="$HOME/Audio/Bjornulf/$LANGUAGE/$SPEAKER"`)  
It will not try to regenerate the audio file if it already exists! (So the TTS server doesn't need to be running to use this script - if you know you have the audio file already)  
For example, you can generate an audio file `system is operational` and you can safely use my script to simply play the audio when your computer starts.  
I recommend to use with an alias in .bashrc/.zshrc, for example something like :

```
alias bjornulf_tts='/path/of/your/Bjornulf_XTTS/bjornulf_tts.sh
alias tts='/path/of/your/Bjornulf_XTTS/bjornulf_tts.sh
alias talk='/path/of/your/Bjornulf_XTTS/bjornulf_tts.sh
```

After that you can use it like this :

```
tts hello world
talk hello world
```

You can also create language and speaker aliases in the script if you want to use them often.  

Example :
```
alias parler='/path/of/your/Bjornulf_XTTS/bjornulf_tts.sh -l fr -s fr/une_voix'
```

After that you can use it like this :

```
parler "Bonjour tout le monde."
```