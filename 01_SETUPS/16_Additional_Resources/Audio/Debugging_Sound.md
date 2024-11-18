<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Debugging Sound</title>
<style>
  /* Generic style */
  body {
       font-family: Arial, sans-serif;
       line-height: 1.6;
       margin: 10px;
       max-width: 800px; /* Limit screen maximum width */
       margin-left: auto;
       margin-right: auto;
  }
   h1, h2, h3, h4, h5, h6 {
       font-weight: bold;
       margin-bottom: 0.5em;
  }
   h1 {
       font-size: 2.5em;
       line-height: 1.2;
  }
   h2 {
       font-size: 2em;
       line-height: 1.3;
  }
   h3 {
       font-size: 1.8em;
       line-height: 1.4;
  }
   p {
       margin: 1em 0;
       text-align: justify; /* Justify text for better readability */
  }
   a {
       color: #007bff;
       text-decoration: none;
  }
   a:hover {
       text-decoration: underline;
  }
   blockquote {
       margin: 1em 0;
       padding: 0 1em;
       border-left: 3px solid #ccc;
  }
   blockquote cite {
       font-style: italic;
  }
   img {
       max-width: 100%;
       height: auto;
       display: block;
       margin: 1em 0;
  }
   pre {
       background-color: #f8f9fa;
       border: 1px solid #ccc;
       padding: 1em;
       overflow: auto;
       white-space: pre-wrap; /* Wrap long lines in preformatted text */
  }
   code {
       font-family: Consolas, Monaco, 'Andale Mono', monospace;
       font-size: 0.9em;
  }
  /* Tables */
   table {
       width: 100%;
       border-collapse: collapse;
       margin-bottom: 1em;
  }
   th, td {
       border: 1px solid #ccc;
       padding: 0.8em;
  }
   th {
       background-color: #f2f2f2;
  }
  /* Lists */
   ul, ol {
       margin: 1em 0;
       padding-left: 2em;
  }
  /* Miscellaneous */
   sup {
       vertical-align: super;
       font-size: smaller;
  }
   sub {
       vertical-align: sub;
       font-size: smaller;
  }
   @media screen and (max-width: 600px) {
      /* Adjustments for smaller screens */
       body {
           font-size: 16px; /* Font size for better readability */
           line-height: 1.5;
           margin: 0.5em;
      }
       h1 {
           font-size: 2em;
      }
       h2 {
           font-size: 1.8em;
      }
       h3 {
           font-size: 1.6em;
      }
       th, td {
           padding: 0.6em;
      }
       pre {
           padding: 0.5em;
      }
  }
</style>
</head>
<body>
  
  <h2>Debugging Sound</h2>
  
  <ul>
      <li><a href="https://wiki.ubuntu.com/DebuggingSoundProblems" target="_blank">Ubuntu Debugging Sound Problems</a></li>
      <li><a href="https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture" target="_blank">Arch Linux: Advanced Linux Sound Architecture</a></li>
      <li><a href="https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture/Troubleshooting" target="_blank">Arch Linux: ALSA Troubleshooting</a></li>
      <li><a href="https://wiki.archlinux.org/title/PulseAudio/Troubleshooting" target="_blank">Arch Linux: PulseAudio Troubleshooting</a></li>
      <li><a href="https://thesofproject.github.io/latest/getting_started/intel_debug/suggestions.html" target="_blank">SOF Project: Intel Debug Suggestions</a></li>
      <li><a href="https://wiki.debian.org/Sound" target="_blank">Debian Sound Wiki</a></li>
      <li><a href="https://wiki.debian.org/SoundConfiguration" target="_blank">Debian Sound Configuration</a></li>
      <li><a href="https://alsa-project.org" target="_blank">ALSA Project</a></li>
      <li><a href="https://www.kernel.org/doc/html/latest/sound/alsa-configuration.html" target="_blank">ALSA Kernel.org</a></li>
      <li><a href="https://github.com/thesofproject/sof/issues" target="_blank">SOF Project Issues on GitHub</a></li>
      <li><a href="https://github.com/thesofproject" target="_blank">SOF Project on GitHub</a></li>
  </ul>
  
  <h4>Comparison of Sound Systems</h4>

  <table>
    <tr>
      <th>Feature</th>
      <th>ALSA</th>
      <th>PulseAudio</th>
      <th>PipeWire</th>
    </tr>
    <tr>
      <td>Type</td>
      <td>Low-level audio API</td>
      <td>Audio server</td>
      <td>Multimedia server</td>
    </tr>
    <tr>
      <td>Latency</td>
      <td>Low latency</td>
      <td>Higher latency</td>
      <td>Low latency</td>
    </tr>
    <tr>
      <td>Use Cases</td>
      <td>Direct hardware access</td>
      <td>Desktop audio management</td>
      <td>Audio & video handling</td>
    </tr>
    <tr>
      <td>Support for Applications</td>
      <td>Basic, requires application support</td>
      <td>Widely supported</td>
      <td>Compatible with modern applications</td>
    </tr>
    <tr>
      <td>Mixing & Routing</td>
      <td>No built-in mixing</td>
      <td>Software mixing</td>
      <td>Advanced mixing and routing</td>
    </tr>
    <tr>
      <td>Community & Development</td>
      <td>Stable, but less active</td>
      <td>Active, mature project</td>
      <td>Active development</td>
    </tr>
  </table>

  <h4>Packages</h4>

  <table>
    <tr>
      <th>Category</th>
      <th>ALSA</th>
      <th>PulseAudio</th>
      <th>PipeWire</th>
    </tr>
    <tr>
      <td>Backend</td>
      <td>alsa-base, alsa-utils</td>
      <td>pulseaudio, pulseaudio-utils</td>
      <td>pipewire, pipewire-pulse</td>
    </tr>
    <tr>
      <td>Session Manager</td>
      <td>N/A</td>
      <td>N/A</td>
      <td>pipewire-media-session</td>
    </tr>
    <tr>
      <td>GUI Tools</td>
      <td>alsamixer, alsaplayer</td>
      <td>pavucontrol, paprefs</td>
      <td>pavucontrol, qpwgraph</td>
    </tr>
    <tr>
      <td>Bluetooth</td>
      <td>bluez-alsa</td>
      <td>pulseaudio-bluetooth</td>
      <td>pipewire, pipewire-media-session</td>
    </tr>
    <tr>
      <td>Plugins</td>
      <td>alsa-plugins</td>
      <td>pulseaudio-module-bluetooth</td>
      <td>pipewire-alsa</td>
    </tr>
  </table>

  <h4>Configuration Files</h4>

  <table>
    <tr>
      <th>System</th>
      <th>Default Location</th>
    </tr>
    <tr>
      <td>ALSA</td>
      <td>/etc/asound.conf, ~/.asoundrc</td>
    </tr>
    <tr>
      <td>PulseAudio</td>
      <td>/etc/pulse/daemon.conf, ~/.config/pulse/</td>
    </tr>
    <tr>
      <td>PipeWire</td>
      <td>/etc/pipewire/pipewire.conf, ~/.config/pipewire/</td>
    </tr>
  </table>

  <h4>SystemD and OpenRC Services</h4>

  <table>
    <tr>
      <th>System</th>
      <th>SystemD Service</th>
      <th>OpenRC Service</th>
    </tr>
    <tr>
      <td>ALSA</td>
      <td>N/A (handled by kernel)</td>
      <td>N/A (handled by kernel)</td>
    </tr>
    <tr>
      <td>PulseAudio</td>
      <td>pulseaudio.service</td>
      <td>pulseaudio</td>
    </tr>
    <tr>
      <td>PipeWire</td>
      <td>pipewire.service</td>
      <td>pipewire</td>
    </tr>
  </table>
  
  <h4>Environment Variables</h4>

  <table>
    <thead>
      <tr>
        <th>System</th>
        <th>Important Environment Variables</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>ALSA</td>
        <td>
          <span class="important">ALSA_CARD</span>,
          <span class="important">ALSA_CONFIG</span>,
          <span class="important">ALSA_DEVICE</span>,
          <span class="important">ALSA_DEBUG</span>,
          <span class="important">ALSA_PCM</span>
        </td>
      </tr>
      <tr>
        <td>PulseAudio</td>
        <td>
          <span class="important">PULSE_SINK</span>,
          <span class="important">PULSE_SOURCE</span>,
          <span class="important">PULSE_SERVER</span>,
          <span class="important">PULSE_COOKIE</span>,
          <span class="important">PULSE_RUNTIME_PATH</span>
        </td>
      </tr>
      <tr>
        <td>PipeWire</td>
        <td>
          <span class="important">PIPEWIRE_PULSE_SERVER</span>,
          <span class="important">PIPEWIRE_DEBUG</span>,
          <span class="important">PIPEWIRE_MEDIA_SESSION</span>,
          <span class="important">PIPEWIRE_LATENCY</span>
        </td>
      </tr>
      <tr>
        <td>JACK</td>
        <td>
          <span class="important">JACK_SERVER_PATH</span>,
          <span class="important">JACK_DEFAULT_SERVER</span>,
          <span class="important">JACK_OPTIONS</span>
        </td>
      </tr>
      <tr>
        <td>Sound Preferences</td>
        <td>
          <span class="important">SOUND_OUTPUT_DEVICE</span>,
          <span class="important">SOUND_VOLUME</span>,
          <span class="important">SOUND_MUTE</span>
        </td>
      </tr>
    </tbody>
  </table>

  <h4>Module Options</h4>
  
  <p>Edited in <code>/etc/modprobe.d/alsa-base.conf</code></p>
  
  <table>
    <thead>
      <tr>
        <th>Module</th>
        <th>Option</th>
        <th>Description</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>snd-hda-intel</td>
        <td><span class="important">model=generic</span></td>
        <td>Uses the generic model for the audio device.</td>
      </tr>
      <tr>
        <td>snd-hda-intel</td>
        <td><span class="important">probe_mask=1</span></td>
        <td>Limits the probing to the first codec slot.</td>
      </tr>
      <tr>
        <td>snd-hda-intel</td>
        <td><span class="important">index=<num></span></td>
        <td>Assigns a specific index to the sound card (0-31).</td>
      </tr>
      <tr>
        <td>snd-hda-intel</td>
        <td><span class="important">enable=0</span></td>
        <td>Disables the audio device.</td>
      </tr>
      <tr>
        <td>snd-hda-intel</td>
        <td><span class="important">position_fix=<num></span></td>
        <td>Adjusts the DMA pointer for audio playback.</td>
      </tr>
    </tbody>
  </table>
  
  <!-- ########## -->

  <h4>Hardcore Sound Solution</h4>
  
  <pre><code><span>$ </span>sudo cp /etc/modprobe.d/alsa-base.conf /etc/modprobe.d/alsa-base.conf.bak</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo cp /etc/modprobe.d/alsa-base.conf /etc/modprobe.d/alsa-base.conf.bak')">Copy</button>
  
  <pre><code><span>$ </span>r ~/.config/pulse</code></pre>
  <button onclick="navigator.clipboard.writeText('rm -r ~/.config/pulse')">Copy</button>
  
  <pre><code><span>$ </span>sudo apt install --reinstall alsa-base alsa-utils linux-sound-base libasound2</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install --reinstall alsa-base alsa-utils linux-sound-base libasound2')">Copy</button>
  
  <pre><code><span>$ </span>sudo apt install --reinstall libpulse0 lipulsedsp pulseaudio pulseaudio-module-bkuetooth pulseaudio-utils</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install --reinstall libpulse0 lipulsedsp pulseaudio pulseaudio-module-bkuetooth pulseaudio-utils')">Copy</button>
  
  <!-- ########## -->

  <h4>1. Install Required Firmware</h4>

  <p>To ensure proper audio functionality on your system, install the necessary firmware packages. Depending on your hardware, consider installing the following:</p>

  <pre><code><span>$ </span>sudo apt install firmware-sof-signed</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install firmware-sof-signed')">Copy</button>
  <pre><code><span>$ </span>sudo apt install firmware-intel-sound</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install firmware-intel-sound')">Copy</button>
  <pre><code><span>$ </span>sudo apt install linux-firmware</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install linux-firmware')">Copy</button>
  <pre><code><span>$ </span>sudo apt install firmware-realtek</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install firmware-realtek')">Copy</button>
  <pre><code><span>$ </span>sudo apt install firmware-atheros</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install firmware-atheros')">Copy</button>

  <p>After installing these firmware packages, reboot your system to apply the changes.</p>


  <!-- ########## -->

  <h4>2. Debugging Commands</h4>

  <p>These commands will help you gather information about your audio hardware:</p>

  <h5>Playback Hardware Devices:</h5>
  <pre><code><span>$ </span>aplay -l</code></pre>
  <button onclick="navigator.clipboard.writeText('aplay -l')">Copy</button>
  <pre><code><span>$ </span>lspci | grep -i audio</code></pre>
  <button onclick="navigator.clipboard.writeText('lspci | grep -i audio')">Copy</button>
  <pre><code><span>$ </span>cat /proc/asound/cards</code></pre>
  <button onclick="navigator.clipboard.writeText('cat /proc/asound/cards')">Copy</button>
  <pre><code><span>$ </span>cat /proc/asound/card*/id</code></pre>
  <button onclick="navigator.clipboard.writeText('cat /proc/asound/card*/id')">Copy</button>

  <h5>Capture Hardware Devices:</h5>
  <pre><code><span>$ </span>arecord -l</code></pre>
  <button onclick="navigator.clipboard.writeText('arecord -l')">Copy</button>

  <h5>Additional Debug Commands:</h5>
  <pre><code><span>$ </span>cat /proc/asound/modules</code></pre>
  <button onclick="navigator.clipboard.writeText('cat /proc/asound/modules')">Copy</button>
  <pre><code><span>$ </span>lspci -v | grep -A7 -i audio</code></pre>
  <button onclick="navigator.clipboard.writeText('lspci -v | grep -A7 -i audio')">Copy</button>
  <pre><code><span>$ </span>lsusb</code></pre>
  <button onclick="navigator.clipboard.writeText('lsusb')">Copy</button>
  <pre><code><span>$ </span>lsmod | grep snd</code></pre>
  <button onclick="navigator.clipboard.writeText('lsmod | grep snd')">Copy</button>
  <pre><code><span>$ </span>aplay -L</code></pre>
  <button onclick="navigator.clipboard.writeText('aplay -L')">Copy</button>
  <pre><code><span>$ </span>amixer</code></pre>
  <button onclick="navigator.clipboard.writeText('amixer')">Copy</button>
  <pre><code><span>$ </span>amixer -c 0</code></pre>
  <button onclick="navigator.clipboard.writeText('amixer -c 0')">Copy</button>
  <pre><code><span>$ </span>sudo dpkg-reconfigure linux-sound-base</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo dpkg-reconfigure linux-sound-base')">Copy</button>
  <pre><code><span>$ </span>sudo alsa-info</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo alsa-info')">Copy</button>

  <!-- ########## -->

  <h4>3. Audio Testing</h4>

  <p>To test audio playback, use the following command:</p>
  <pre><code><span>$ </span>speaker-test</code></pre>
  <button onclick="navigator.clipboard.writeText('speaker-test')">Copy</button>

  <!-- ########## -->

  <h4>4. ALSA (Advanced Linux Sound Architecture)</h4>

  <p>ALSA is a vital component of the Linux kernel that manages sound devices. For enhanced audio management, you may want to install ALSA utilities:</p>

  <pre><code><span>$ </span>sudo apt install alsa-utils</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install alsa-utils')">Copy</button>
  <pre><code><span>$ </span>alsamixer</code></pre>
  <button onclick="navigator.clipboard.writeText('alsamixer')">Copy</button>

  <p>Here are some useful commands for adjusting audio settings:</p>
  <pre><code><span>$ </span>amixer -c 0 set Master 100%</code></pre>
  <button onclick="navigator.clipboard.writeText('amixer -c 0 set Master 100%')">Copy</button>
  <pre><code><span>$ </span>amixer -c 1 set Speaker 50%</code></pre>
  <button onclick="navigator.clipboard.writeText('amixer -c 1 set Speaker 50%')">Copy</button>
  <pre><code><span>$ </span>amixer -c 1 set Speaker 3dB</code></pre>
  <button onclick="navigator.clipboard.writeText('amixer -c 1 set Speaker 3dB')">Copy</button>
  <pre><code><span>$ </span>amixer -c 1 set Speaker 2dB+</code></pre>
  <button onclick="navigator.clipboard.writeText('amixer -c 1 set Speaker 2dB+')">Copy</button>
  <pre><code><span>$ </span>amixer -c 0 set Mic unmute</code></pre>
  <button onclick="navigator.clipboard.writeText('amixer -c 0 set Mic unmute')">Copy</button>
  <pre><code><span>$ </span>sudo nano /etc/pulse/default.pa</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo nano /etc/pulse/default.pa')">Copy</button>

  <!-- ########## -->

  <h4>5. PulseAudio Volume Control</h4>

  <p>PulseAudio acts as an intermediary between applications and ALSA, facilitating better control over audio streams. To install PulseAudio Volume Control:</p>

  <pre><code><span>$ </span>sudo apt install pavucontrol</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install pavucontrol')">Copy</button>

  <!-- ########## -->

  <h4>6. Advanced Solutions for Audio Issues</h4>

  <p>If you're experiencing issues with your audio hardware, consider installing the Sound Open Firmware (SOF). This can improve compatibility and performance for newer audio devices:</p>

  <p>1. Clone the SOF firmware repository from GitHub:</p>
  <pre><code><span>$ </span>git clone https://github.com/thesofproject/sof-bin.git</code></pre>
  <button onclick="navigator.clipboard.writeText('git clone https://github.com/thesofproject/sof-bin.git')">Copy</button>

  <p>2. Navigate into the cloned directory:</p>
  <pre><code><span>$ </span>cd sof-bin</code></pre>
  <button onclick="navigator.clipboard.writeText('cd sof-bin')">Copy</button>

  <p>3. Follow the installation instructions provided in the repository: <a href="https://github.com/thesofproject/sof-bin#install-process-with-installsh">Install Process</a></p>

  <p>4. Backup existing firmware (if necessary):</p>
  <pre><code><span>$ </span>sudo mv /lib/firmware/intel/sof* some_backup_location/</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo mv /lib/firmware/intel/sof* some_backup_location/')">Copy</button>
  <pre><code><span>$ </span>sudo mv /usr/local/bin/sof-* some_backup_location/ # optional</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo mv /usr/local/bin/sof-* some_backup_location/ # optional')">Copy</button>

  <p>5. Install the SOF firmware:</p>
  <pre><code><span>$ </span>sudo ./install.sh v2.2.x/v2.2</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo ./install.sh v2.2.x/v2.2')">Copy</button>

  <p>6. Finally, reboot your system to apply the changes:</p>
  <pre><code><span>$ </span>sudo reboot</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo reboot')">Copy</button>

  <p>For users with the "Apollo Lake" platform, further information can be found at <a href="https://thesofproject.github.io/latest/getting_started/intel_debug/suggestions.html#es8336-support">SOF Project Intel Debug</a>.</p>

  <p>Additionally, check your kernel configuration (usually found at /boot/config-*). Ensure the following options are enabled for Sound Open Firmware:</p>

  <pre><code><span>$ </span>grep SND_SOC_INTEL_APL /boot/config-*</code></pre>
  <button onclick="navigator.clipboard.writeText('grep SND_SOC_INTEL_APL /boot/config-*')">Copy</button>

  <p>You should have these options set:</p>
  <pre>ALSA for SoC audio support (CONFIG_SND_SOC=m)
  Intel ASoC SST drivers (CONFIG_SND_SOC_INTEL_SST_TOPLEVEL=y)
  Broxton/Apollo Lake platforms (CONFIG_SND_SOC_INTEL_APL=m)</pre>

  <p>Other necessary configurations include:</p>
  <pre>Sound Open Firmware support (CONFIG_SND_SOC_SOF_TOPLEVEL=y)
  SOF support for Intel Audio DSPs (CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL=y)
  SOF PCI enumeration support (CONFIG_SND_SOC_SOF_PCI=m)
  SOF support for Apollo Lake (CONFIG_SND_SOC_SOF_APOLLOLAKE_SUPPORT=m)
  SOF support for HDA Links (HDA/HDMI) (CONFIG_SND_SOC_SOF_HDA_LINK=y)
  SOF support for HDAudio codecs (CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC=y)</pre>
  
</body>
</html>