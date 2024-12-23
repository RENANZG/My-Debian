
####################

Enable audio feature in StandaloneVM (HVM mode):

Command in dom0:

sudo qvm-features <StandaloneVM_Name> audio-model ich6

Maybe you need to reboot.

####################

Enable audio with sys-audio (qube audio)

https://www.qubes-os.org/doc/audio-virtualization/

Audio with sys-audio:

sudo qubesctl state.sls qvm.sys-audio

####################

Other commands:

sudo modprobe -vr snd-hda-intel
sudo modprobe -v snd-hda-intel

sudo systemctl status alsa-state.service
sudo alsa force-reload
sudo alsactl dump-state

####################

StandaloneVM command:

pulseaudio-qubes-tools

####################

rm -r ~/.config/pulse

sudo apt install --reinstall alsa-base alsa-utils linux-sound-base libasound2

sudo apt install --reinstall libpulse0 lipulsedsp pulseaudio pulseaudio-module-bkuetooth pulseaudio-utils
