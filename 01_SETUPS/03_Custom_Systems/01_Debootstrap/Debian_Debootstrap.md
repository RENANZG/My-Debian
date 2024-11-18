<!DOCTYPE html>
<html lang="en">
<!--
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Debian Installation Guide with Encrypted LVM</title>
<style>
    /* Debian Color Theme */
    body {
      background-color: #EEEEEE;
      border: 40px solid #EEEEEE;
      margin: 0;
      padding: 0 10px;
      font-family: "Liberation Sans", "Myriad", "Bitstream Vera Sans", "Lucida Grande", "Luxi Sans", "Trebuchet MS", helvetica, verdana, arial, sans-serif;
      line-height: 1.2em;
    }
    /* Container styles */
    body > div.book, body > div.article, body > div.set, body >  
      div.preface, body > div.chapter, body > div.section, body >
      div.appendix, body > div.part, div.sect1 {
      margin-top : 0;
      padding : 2em;
      background-color : #FFFFFF;
      margin : 40px auto 4em;
      padding : 1px 40px 20px 30px;
    }
    /* Typography */
    h1, h2, h3, h4, h5, h6 {
        color: #C70036;
    }
    h1 {
        line-height: 1.1em;
    }
    /* Links */
    a:link {
        color: #0035C7;
        text-decoration: none;
    }
    a:visited {
        color: #00207A;
        text-decoration: none;
    }
    a:hover {
        color: #00207A;
        text-decoration: underline;
    }
    /* Code and Preformatted Text */
    code {
        font-family: "Liberation Mono", "Bitstream Vera Mono", "DejaVu Mono", monospace;
        font-weight: bold;
        word-wrap: break-word;
    }
    pre {
        background-color: #F5F5F5;
        border-radius: 0.5em;
        color: #000000;
        display: block;
        font-family: "Liberation Mono", "Bitstream Vera Mono", "DejaVu Mono", monospace;
        font-size: 0.9em;
        margin-bottom: 1em;
        padding: 0.5em;
        white-space: pre-wrap;
        word-wrap: break-word;
    }
    /* Tables */
    table {
        border-collapse: collapse;
    }
    th,
    td {
        border: 1px solid black;
        padding: 0.2em 0.5em;
    }
    th {
        background-color: #C70036;
    }
    th:hover {
        color: white;
    }
    /* Lists */
    ul,
    ol {
        padding-left: 1.5em;
    }
    li {
        margin-bottom: 0.5em;
    }
    /* Blockquote */
    blockquote {
        border-left: 4px solid #CCCCCC;
        padding-left: 1em;
        margin-left: 0;
        color: #666666;
    }
    /* Horizontal Rule */
    hr {
        border-top: 1px dotted #808080;
        margin: 0;
    }
    /* Additional Tags */
    b, i, strong, em, img, tt, div, ins, del, sup, sub, p, thead, tbody, tfoot, dl, dt, dd, kbd, q, samp, var, ruby, rt, rp, tr, td, th, s, strike, summary, details {
    /* Specific styles for these elements can be added here */
    }
    /* Special classes */
    .important {
        border: 1px dashed red;
    }
    .caution {
        border: 1px dashed #EFF500;
    }
    .note {
        border: 1px dashed blue;
    }
    .important,
    .caution,
    .note,
    .tip {
        margin-left: 1em;
        margin-right: 1em;
    }
    /* Reference blocks */
    .references {
        margin-top: 10px;
    }
    .reference-list {
        list-style-type: none;
        padding-left: 0;
    }
    .reference-list li::before {
        content: '[' counter(ref) '] ';
        counter-increment: ref;
        font-size: 0.2em;
        font-weight: bold;
    }
</style>
</head>
-->
<body>
  <h1>Installing Debian GNU/Linux with Encrypted LVM using debootstrap</h1>

  <h2>Getting Started</h2>
  
  <ul>
  <li>There are various methods to begin a debootstrap and chroot environment.</li>
  <ul>
    <li>Booting from ISO:</li>
    <ul>
      <li>Do a bootable USB drive with the Debian NetInst, Live ISO or DVD.In
        Windows, you could write the image with Balena Etcher, Ventoy or
        Rufus. In Android, with EtchDroid.</li>
      <li>Boot from the Debian ISO and select "Rescue mode" to access a command-line
        interface.</li>
    </ul>
    <li>Using a Live CD/USB</li>
    <ul>
      <li>Boot into a Debian Live environment, which typically includes a terminal
        with sudo enabled by default.</li>
    </ul>
    <li>Existing Linux System:</li>
    <ul>
      <li>Open a terminal and follow similar steps to create a directory, run
        debootstrap, and chroot into the new environment.</li>
    </ul>
    <li>Switching to TTY Session:</li>
    <ul>
      <li>During the ISO installation process press <code>Ctrl + Alt + F2</code>
        (or another function key such as F3, F4, etc.) to switch to a virtual
        terminal (TTY) session.</li>
    </ul>
  </ul>
  </ul>
  
<small>
  <ul>
    <li>Notes</li>
    <ul>
      <li>Set BIOS to first boot from USB stick and maintain enable Secure Boot, however, if booting from the USB is failing, turn off Secure Boot in the BIOS.
      </li>
      <li>Put a admin password in your BIOS and do not use the same for your disk encryption, do not reuse passwords. Strong password was at least 20 characters.</li>
      <li>You could disable fast boot to avoid issues with Linux.</li>
      <li>If you want to adopt strong secure measures, read about disk sanitation, password entropy, device airgap, BIOS write-protection, Coreboot BIOS, tamper-proofing, kernel runtime guard, anti evil maid, multi-factor authentication, nuke password, custom secure boot keys, hidden encrypted volumes.</li>
    </ul>
  </ul>
  </small>

  <small>
  <ul>
    <li>Glossary</li>
    <ul>
      <li><code>debootstrap</code>: A tool specifically for creating a minimal Debian-based system within another system.</li>
      <li><code>chroot</code>: A command that changes the root directory for a process, creating an isolated environment.</li>
      <li><code>bootstrap</code>: A general term referring to the process of starting a system or setting up an initial environment, not specific to any tool.</li>
    </ul>
  </ul>
  </small>

  <h2>Steps</h2>

  <h3>1. Boot from the Debian Installation Media</h3>

  <p>Boot from your Debian installation media (USB).</p>

  <p>There are many ways to achieve an terminal. Select the "Advanced options" and then the "Rescue mode" to access a command-line interface, you could switch to a teletype (TTY) session pressing <code>Ctrl + Alt + F2</code>, or you could use the Live that has a terminal with sudo enabled by default.</p>

  <h3>2. Prepare the Disk</h3>

  <p>Securely prepare your storage. Compared to HDDs, SSDs have a different architecture, then, using <code>dd</code> for secure wipe might not always be the most efficient method due to the wear-leveling algorithms in SSDs.If you want strong secure approach, search for <a href="">secure erase disk</a>.</p>

  <p>For a quick wipe:</p>

  <pre><code>
  sudo dd if=/dev/zero of=/dev/sda bs=1M status=progress
  </code></pre>

  <p>Suggested minimal partitioning layout LVM on LUKS ("Full-disk encryption") with swap and home for a 32 GB (29.80232 GiB) of space</p>

  <pre>
  +------------+-----------------------------------------------------------+
  |     ESP    |                LUKS2 Encryption  /dev/sda2                |
  +------------+-----------------------------------------------------------+
  | EFI System |                 LVM2 Group  /dev/host-vg                  |
  |            +-------------------+-------------------+-------------------+
  | /dev/sda1  | Logical volume 1  | Logical volume 2  | Logical volume 3  |
  |            |                   |                   |                   |
  |            | /dev/host-vg/swap | /dev/host-vg/root | /dev/host-vg/home |
  |            |                   |                   |                   |
  | 100MiB     | 4GiB              | 12GiB             | 13.7GiB           |
  |            |                   |                   |                   |
  | fat32      | swap              | ext4              | ext4              |
  | /boot/efi  | [SWAP]            | /                 | /home             |
  +------------+-------------------+-------------------+-------------------+
  </pre>

  <p>Alternative suggestion for a minimal 64 GB (59.60464 GiB).</p>

  <pre>
  +------------+-----------------------------------------------------------+
  |     ESP    |                LUKS2 Encryption  /dev/sda2                |
  +------------+-----------------------------------------------------------+
  | EFI System |                 LVM2 Group  /dev/host-vg                  |
  |            +-------------------+-------------------+-------------------+
  | /dev/sda1  | Logical volume 1  | Logical volume 2  | Logical volume 3  |
  |            |                   |                   |                   |
  |            | /dev/host-vg/swap | /dev/host-vg/root | /dev/host-vg/home |
  |            |                   |                   |                   |
  | 100MiB     | 4GiB              | 25GiB             | 30.5GiB           |
  |            |                   |                   |                   |
  | fat32      | swap              | ext4              | ext4              |
  | /boot/efi  | [SWAP]            | /                 | /home             |
  +------------+-------------------+-------------------+-------------------+
  </pre>

  <p>Alternative suggestion for a minimal 256 GB nvme (238.41858 GiB).</p>

  <pre>
  +----------------+-----------------------------------------------------------+
  |      ESP       |                 LUKS2 Encryption  /dev/nvme0n1p2          |
  +----------------+-----------------------------------------------------------+
  |   EFI System   |                  LVM2 Group  /dev/host-vg                 |
  |                +-------------------+-------------------+-------------------+
  | /dev/nvme0n1p1 | Logical volume 1  | Logical volume 2  | Logical volume 3  |
  |                |                   |                   |                   |
  |                | /dev/host-vg/swap | /dev/host-vg/root | /dev/host-vg/home |
  |                |                   |                   |                   |
  | 100MiB         | 8GiB              | 50GiB             | 80.3GiB           |
  |                |                   |                   |                   |
  | fat32          | swap              | ext4              | ext4              |
  | /boot/efi      | [SWAP]            | /                 | /home             |
  +----------------+-------------------+-------------------+-------------------+
  </pre>


<small>
  <ul>
    <li>Notes</li>
    <ul>
      <li>For tasks such as running a Language Model (LLM) or managing multiple large datasets, a minimum disk space of 50-100GB is recommended.
      </li>
      <li>As of mid-2024, running a Bitcoin node typically requires approximately 400-500 GB of disk space for storing the entire blockchain. In comparison, a Monero (XMR) node generally needs around 100-150 GB for its blockchain data.</li>
    </ul>
  </ul>
  </small>
  
  <p>To find your devices:</p>

  <pre><code>lsblk</code></pre>
  <pre><code>lsblk -o NAME,UUID</code></pre>
  <pre><code>sudo blkid</code></pre>

  <p>Use <code>fdisk</code> or <code>parted</code> to create the necessary partitions:</p>

  <pre><code>fdisk /dev/sda</code></pre>

  <p>Select /dev/sda and create a new empty GPT partition table on it pressing <code>g</code> command.</p>

  <p>After create a small EFI system partition (ESP) and then we will create an encrypted partition for LVM (LUKS over LVM):</p>

  <ul>
    <li><code>/dev/sda1</code>: Created a new partition type 1 'Linux filesystem' with size 100 MiB for <code>/boot/efi</code></li>
    <li><code>/dev/sda2</code>: Encrypted LVM partition <code>sda2_crypt</code></li>
  </ul>

  <pre>
  Partition number (1-128, default 1): Enter
  First sector (2048-62910271, default 2048): Enter
  Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-62910271, default 62910271): +100M
  </pre>

  <p>Use the <code>p</code> command to display the new partition table and <code>w</code> to write.</p>

  <p>Alternative one-line command:</p>

  <pre>
  echo -e "n\np\n1\n\n+100M\nw" | sudo fdisk /dev/sda
  </pre>

  <p><small>To ensure that the partition shows up as exactly 100 MiB in GNOME Disks or GParted, specify
  the size of the partition in sectors. To create a 100 MiB partition, type +204800 (since 100 MiB × 2048
  sectors/MiB = 204800 sectors) and press Enter. One-line command:
  <code>echo -e "n\np\n1\n\n+204800\nw" | sudo fdisk /dev/sda</code></small></p>

  <p>You could choose a specific size for the rest of the partition, like 30GiB:</p>

  <pre><code>echo -e "n\np\n1\n\n+30G\nw" | sudo fdisk /dev/sda2</code></pre>

  <h3>3. Encrypt the Partition</h3>

  <p>Encrypt the chosen partition (<code>/dev/sda2</code>).</p>

  <pre><code>apt install cryptsetup</code></pre>
  <pre><code>cryptsetup luksFormat --type luks2 /dev/sda2</code></pre>
  <pre><code>Passphrase: ImSureIWillRememberThisLongPasswordFromEFFDiceTip</code></pre>

  <h3>4. Open the Encrypted Partition</h3>

  <p>Open the encrypted partition using a mapper device name (e.g., <code>sda2_crypt</code>):</p>

  <pre><code>cryptsetup open /dev/sda2 sda2_crypt</code></pre>

  <h3>5. Create LVM Volumes</h3>

  <p>Set up LVM on the opened partition (<code>/dev/mapper/sda2_crypt</code>):</p>

  <pre><code>
  apt install lvm2
  pvcreate /dev/mapper/sda2_crypt
  vgcreate host-vg /dev/mapper/sda2_crypt
  lvcreate -L 4G -n swap host-vg
  lvcreate -L 12G -n root host-vg
  lvcreate -l +100%FREE -n home host-vg
  </code></pre>

  <h3>6. Format Filesystems</h3>

  <p>Format the logical volumes:</p>

  <pre><code>
  # Format swap volume
  mkswap /dev/host-vg/swap
  # Format root volume
  mkfs.ext4 /dev/host-vg/root
  # Format home volume
  mkfs.ext4 /dev/host-vg/home
  </code></pre>

  <small>
  <ul>
    <li>Note</li>
    <ul>
      <li>File systems such as <a href="http://xfs.org/index.php/Main_Page">XFS</a>, <a href="https://btrfs.wiki.kernel.org/index.php/Main_Page">Btrfs</a> and <a href="https://openzfs.org/">ZFS</a> require an advanced approach.</li>
    </ul>
  </ul>
  </small>

  <h3>7. Mount Filesystems</h3>

  <p>Mount the root filesystem (<code>/dev/host-vg/root</code>) to <code>/mnt</code>:</p>

  <pre><code>
  mount /dev/host-vg/root /mnt
  </code></pre>

  <p>Create and mount the home directory:</p>

  <pre><code>
  mkdir /mnt/home
  mount /dev/host-vg/home /mnt/home
  </code></pre>

  <p>Mount the ESP (<code>/dev/sda1</code>):</p>

  <pre><code>
  mkdir -p /mnt/boot/efi
  mount /dev/sda1 /mnt/boot/efi
  </code></pre>

  <h3>8. Download and install the base system into a target with debootstrap</h3>

  <p>Install <code>debootstrap</code> if not already installed:</p>

  <pre><code>apt update</code></pre>
  <pre><code>apt install debootstrap</code></pre>

  <p>Use <code>debootstrap</code> to copy the base Debian system into <code>/mnt</code>:</p>

  <pre><code>debootstrap --arch amd64 bookworm /mnt</code></pre>

  <small>
  <ul>
    <li>Notes</li>
    <ul>
      <li>Replace <code>amd64</code> with your architecture codename (e.g., <code>amd64, arm64, armel, armhf, i386, mips, mips64el, mipsel, ppc64el, s390x.</code>).
      </li>
      <li>Replace <code>bookworm</code> with your Debian release codename (e.g., <code>bullseye, buster</code>).</li>
      </ul>
  </ul>
  </small>
  
  <p><small></small></p>

  <p><small></small></p>

  <h3>9. Configure the System</h3>

  <h4>Mount necessary filesystems for the chroot environment:</h4>

  <pre><code>
  mount --make-rslave --rbind /sys /mnt/sys
  mount --make-rslave --rbind /dev /mnt/dev
  mount --make-rslave --rbind /proc /mnt/proc
  mount --make-rslave --rbind /run /mnt/run
  </code></pre>
  
  <p>Alternative one-line command:</p>

  <pre><code>
  for dir in sys dev proc; do mount --rbind /$dir /mnt/$dir && mount --make-rslave /mnt/$dir ; done
  </code></pre>

  <p>Checking mounted filesystems:</p>

  <pre><code>
  cat /proc/mounts
  </code></pre>

  <h4>Chroot into the installed system</h4>
  
  <p>There are several steps after we enter in chroot.</p>
  
  <pre><code>chroot /mnt /bin/bash</code></pre>

  <p>Edit file system table (fstab)</p>

  <a href="https://wiki.archlinux.org/title/Fstab">https://wiki.archlinux.org/title/Fstab</a>

  <p>All specified devices within /etc/fstab will be automatically mounted on system startup.</p>

  <p>It is not recommended to name partitions by kernel name (e.g. /dev/sda1) because it is not persistent and can change each boot. Use UUID or PARTUUID instead, without the quotes.</p>
  
  <pre><code>
  cat /etc/fstab
  </code></pre>
  
  <p>To get the universally unique id (UUID) you can use:</p>

  <pre><code>
  lsblk
  lsblk -f /dev/sda
  sudo blkid -o value -s UUID /dev/sda
  sudo blkid -o value -s PARTUUID /dev/sda
  </code></pre>
  
  <pre><code>
  apt install nano
  nano /etc/fstab
  </code></pre>

  <small>
  <p>Tip for fstab:</p>
  <pre><code>lsblk -o NAME,UUID >> /etc/fstab</code></pre>
  <pre><code>sudo blkid -o value -s UUID -s TYPE >> /etc/fstab</code></pre>
  <pre><code>cp /proc/mounts /etc/fstab</code></pre>
  </small>

  <pre><code>
  # &lt;file system&gt;     &lt;dir&gt;     &lt;type&gt; &lt;options&gt;             &lt;dump&gt; &lt;pass&gt;
  UUID=00-00-00-00-00 /         ext4   defaults                0      1
  UUID=00-00-00-00-00 /home     ext4   defaults                0      2
  
  UUID=00-00-00-00-00 /boot/efi vfat   defaults                0      0
  
  UUID=00-00-00-00-00 none      swap   sw                      0      0
  tmpfs               /tmp      tmpfs  defaults,nosuid,nodev   0      0
  </code></pre>
  
 <h4>Set your repository sources</h4>

  <a href="https://wiki.debian.org/SourcesList">https://wiki.debian.org/SourcesList</a></br>
  <a href="https://backports.debian.org/Instructions">https://backports.debian.org/Instructions</a></br>

  <p>Example to overwrite sources.list:</p>

  <pre><code>
  echo '

  deb http://deb.debian.org/debian/ bookworm main contrib non-free-firmware
  deb-src http://deb.debian.org/debian/ bookworm main contrib non-free-firmware

  deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free-firmware
  deb-src http://deb.debian.org/debian/ bookworm-updates main contrib non-free-firmware

  deb http://security.debian.org/debian-security/ bookworm-security main contrib non-free-firmware
  deb-src http://security.debian.org/debian-security/ bookworm-security main contrib non-free-firmware

  deb http://deb.debian.org/debian bookworm-backports main contrib non-free
  deb-src http://deb.debian.org/debian bookworm-backports main contrib non-free

  ' | sudo tee /etc/apt/sources.list
  </code></pre>

  <p>Example to just append sources.list:</p>

  <pre><code>
  echo '

  deb http://deb.debian.org/debian bookworm-backports main contrib non-free
  deb-src http://deb.debian.org/debian bookworm-backports main contrib non-free

  ' | sudo tee -a /etc/apt/sources.list
  </code></pre>

  <p>Update:</p>

  <pre><code>
  apt update --no-install-recommends
  </code></pre>

  <small>
  <p>To install from backports, examples:</p>
  <pre>
  $ sudo apt install package/bookworm-backports
  $ sudo apt install papirus-icon-theme/bookworm-backports
  $ sudo apt install samba/bookworm-backports
  $ sudo apt install zabbix-agent/bookworm-backports
  $ sudo apt install freedombox/bookworm-backports
  $ sudo apt install gomuks/bookworm-backports
  </pre>
  </small>

  <h4>Local and timezone</h4>

  <p>Set the locales:</p>

  <pre><code>
  apt install --no-install-recommends locales && dpkg-reconfigure locales
  </code></pre>

  <p>Set the timezone:</p>

  <pre><code>
  dpkg-reconfigure tzdata
  </code></pre>

  <p>Set keyboard layout:</p>

  <pre><code>
  apt install console-setup console-setup-linux
  </code></pre>
  
  <p><small>Most commom is Generic 105-key PC.</small></p>

  <p>To change layout:</p>
  
  <pre><code>
  dpkg-reconfigure keyboard-configuration
  systemctl restart console-setup
  </code></pre>
  
  <h4>Install the Kernel and necessary firmware</h4>

  <p>Use <code>intel-microcode</code> if you use an Intel processor or <code>amd64-microcode</code> if you use an AMD processor.</p>

  <pre><code>
  apt search linux-image
  </code></pre>
  
  <pre><code>
  apt install --no-install-recommends linux-image-amd64 intel-microcode firmware-linux-nonfree
  </code></pre>

  <h4>Other system configuration</h4>

  <p>Set your host name:</p>

  <pre><code>
  echo 'host' | sudo tee /etc/hostname
  </code></pre>

  <p>Set the root password:</p>

  <pre><code>
  passwd
  Enter new UNIX password:
  Retype new UNIX password:
  passwd: password updated successfully
  </code></pre>  

  <p>If necessary, create an user and set password:</p>
  
  <pre><code>
  useradd USERNAME -m
  passwd USERNAME
  </code></pre>

  <p>If necessary, add the user to sudo group:</p>

  <pre><code>
  apt install sudo
  usermod -aG sudo USERNAME
  </code></pre>

  <p>Set your network hosts:</p>

  <pre><code>
  nano /etc/hosts
  </code></pre>

  <pre><code>
  127.0.0.1 localhost
  127.0.1.1 $(cat /etc/hostname)

  # The following lines are desirable for IPv6 capable hosts
  ::1     localhost ip6-localhost ip6-loopback
  ff02::1 ip6-allnodes
  ff02::2 ip6-allrouters
  # fe00::0 ip6-localnet
  # ff00::0 ip6-mcastprefix
  # ff02::3 ip6-allhosts
  </code></pre>

  <p>Alternative to edit your network hosts:</p>

  <pre><code>
  sudo sed -i \
    -e '1s/^/127.0.0.1 localhost\n/' \
    -e "2s/^/127.0.1.1 $(cat /etc/hostname)\n/" \
    -e '3s/^/\n/' \
    -e '4s/^/# The following lines are desirable for IPv6 capable hosts\n/' \
    -e '5s/^/::1     localhost ip6-localhost ip6-loopback\n/' \
    -e '6s/^/ff02::1 ip6-allnodes\n/' \
    -e '7s/^/ff02::2 ip6-allrouters/' \
    /etc/hosts
  </code></pre>

  <h4>Configure networking</h4>
  
  <dl>
  <dt>Network Manager</dt>
  <dd><a href="https://wiki.debian.org/NetworkManager">https://wiki.debian.org/NetworkManager</a></dd>
  <dt>Network Configuration</dt>
  <dd><a href="https://wiki.debian.org/NetworkConfiguration">https://wiki.debian.org/NetworkConfiguration</a></dd>
  </dl>

  <p>You could install <code>wpasupplicant</code> or <code>network-manager</code>.</p>

  <pre><code>apt install wpasupplicant</code></pre>
  <p>Or:</p>
  <pre><code>apt install network-manager</code></pre>
  
  <p>Enable networking on boot:</p>

  <pre><code>systemctl enable networking</code></pre>
  <p>Or:</p>
  <pre><code>systemctl enable NetworkManager</code></pre>


  
  <h3>10. Install and Configure Bootloader</h3>

  <p><a href="https://wiki.archlinux.org/title/GRUB">https://wiki.archlinux.org/title/GRUB</a></p>

  <p>A debootstrap installation is mainly used for chroots or containers, therefore it’s missing a few fundamental packages. To have a bootable system, we must install them before we boot the machine for the first time.</p>

  <p>Install GRUB bootloader:</p>

  <pre><code>
  apt install grub-efi
  grub-install /dev/sda
  update-grub
  </code></pre>

  <small>
  <ul>
    <li>Notes</li>
    <ul>
      <li>Don't confuse the disk (e.g. /dev/sda) on which you want grub to be installed, with the partition (e.g. /dev/sda1)</li>
      <li>The <code>grub-efi</code> package contains the GRUB bootloader built for systems using UEFI firmware with GPT partitions.</li>
      <li>The <code>grub2</code> package is the default GRUB package that installs GRUB for both BIOS and UEFI systems, supporting both MBR and GPT partitions.</li>
    </ul>
  </ul>
  </small>
  
  <p></p>

  <h4>Finalizing</h4>
  
  <p>It's possible to exit chroot to finalize the installation now and then reboot, or continue with the installation of the environment.</p>

  <p>Exit the chroot environment and unmount filesystems:</p>

  <pre><code>
  apt clean
  exit
  umount -R /mnt
  cryptsetup close sda2_crypt
  </code></pre>

  <p>Reboot your system:</p>

  <pre><code>
  reboot
  </code></pre>
  
  <h3>11. Finalize environment and exit the chroot</h3>

  <h3>Install the environment</h3>

  <p>Avoid the default packages:</p>

  <pre><code>
  sudo nano /etc/apt/apt.conf.d/99synaptic
  APT::Install-Recommends "0";
  sudo apt update
  </code></pre>

  <p>or</p>

  <pre><code>
  sudo touch /etc/apt/apt.conf.d/99local
  sudo nano /etc/apt/apt.conf.d/99local
  APT::Install-Suggests "0";
  APT::Install-Recommends "0";
  sudo apt update
  </code></pre>

  <h4>Basic method</h4>

  <p>tasksel:</p>

  <pre><code>
  sudo apt install tasksel
  sudo tasksel --list-tasks
  sudo tasksel
  </code></pre>

  <h4>Advanced method</h4>
  
  <h4>Minimal XFCE (Debian-based)</h4>

  <pre><code>
  # Install Intel graphics drivers (optional, replace with appropriate driver for your hardware)
  sudo apt install --no-install-recommends xserver-xorg-video-intel
  # Install AMD graphics drivers (optional, replace with appropriate driver for your hardware)
  sudo apt install --no-install-recommends xserver-xorg-video-amdgpu

  # Install input driver for libinput
  sudo apt install --no-install-recommends xserver-xorg-input-libinput

  # Install XFCE session and core components
  sudo apt install --no-install-recommends xfce4-session xfce4-core

  # Install XFCE panel
  sudo apt install --no-install-recommends xfce4-panel

  # Install XFCE application runner
  sudo apt install --no-install-recommends xfce4-runner

  # Install XFCE's default window manager
  sudo apt install --no-install-recommends xfwm4

  # Install lightdm display manager (default for XFCE on Debian)
  sudo apt install --no-install-recommends lightdm

  # Enable lightdm service to start on boot
  sudo systemctl enable lightdm
  </code></pre>

  
  <h5>XFCE Optional Components</h5>

  <pre><code>
  # Install Thunar (file manager)
  sudo apt install --no-install-recommends thunar
  
  # Install XFCE Terminal (terminal emulator)
  sudo apt install --no-install-recommends xfce4-terminal
  
  # Install XFCE Power Manager (power management tools)
  sudo apt install --no-install-recommends xfce4-power-manager
  
  # Install XFCE Notify Daemon (notification manager)
  sudo apt install --no-install-recommends xfce4-notifyd
  
  # Install XFCE Task Manager (task manager)
  sudo apt install --no-install-recommends xfce4-taskmanager
  
  # Install Xfce4 Clipman Plugin (clipboard manager)
  sudo apt install --no-install-recommends xfce4-clipman-plugin
  
  # Install Mousepad (simple text editor)
  sudo apt install --no-install-recommends mousepad
  
  # Install Xfce4 Mount Plugin (mounting devices)
  sudo apt install --no-install-recommends xfce4-mount-plugin
  
  # Install Xfce4 Panel (taskbar and panel)
  sudo apt install --no-install-recommends xfce4-panel
  
  # Install Xfce4 Session (session manager)
  sudo apt install --no-install-recommends xfce4-session
  
  # Install XFCE Settings Manager (configuration tools)
  sudo apt install --no-install-recommends xfce4-settings
  
  # Install Synaptic (graphical package manager)
  sudo apt install --no-install-recommends synaptic
  
  # Install Ristretto (image viewer)
  sudo apt install --no-install-recommends ristretto
  
  # Install Xfce4 Screenshooter (screenshot tool)
  sudo apt install --no-install-recommends xfce4-screenshooter
  
  # Install Firefox (web browser)
  sudo apt install --no-install-recommends firefox
  
  # Install Thunderbird (email client)
  sudo apt install --no-install-recommends thunderbird
  
  # Install LibreOffice (office suite)
  sudo apt install --no-install-recommends libreoffice
  
  # Install VLC (multimedia player)
  sudo apt install --no-install-recommends vlc
  
  # Install Orage (calendar application)
  sudo apt install --no-install-recommends orage
  
  # Install XFCE App Finder (application finder)
  sudo apt install --no-install-recommends xfce4-appfinder
  
  # Install Catfish (file search tool)
  sudo apt install --no-install-recommends catfish
  
  # Install Xfce4 Places Plugin (quick access to folders)
  sudo apt install --no-install-recommends xfce4-places-plugin
  
  # Install xfce4-goodies (additional plugins and utilities)
  sudo apt install --no-install-recommends xfce4-goodies
  </code></pre>


  <h4>Minimal LXQt (Debian-based)</h4>

  <pre><code>
  # Install Intel graphics drivers (optional, replace with appropriate driver for your hardware)
  sudo apt install --no-install-recommends xserver-xorg-video-intel
  # Install AMD graphics drivers (optional, replace with appropriate driver for your hardware)
  sudo apt install --no-install-recommends xserver-xorg-video-amdgpu
  
  # Install input driver for libinput
  sudo apt install --no-install-recommends xserver-xorg-input-libinput
  
  # Install LXQt session and core components
  sudo apt install --no-install-recommends lxqt-session lxqt-core lxqt-panel lxqt-runner
  
  # Install XFCE's default window manager (optional, replace with LXQt specific if needed)
  sudo apt install --no-install-recommends xfwm4
  
  # Install SDDM display manager (default for LXQt on Debian)
  sudo apt install --no-install-recommends sddm
  
  # Enable SDDM service to start on boot
  sudo systemctl enable sddm
  </code></pre>

  <h5>LXQt Optional Components</h5>
  
  <pre><code>
  # Install QTerminal (terminal emulator)
  sudo apt install --no-install-recommends qterminal
  
  # Install PCManFM-Qt (file manager for LXQt)
  sudo apt install --no-install-recommends pcmanfm-qt
  
  # Install LXQt Task Manager (task manager for LXQt)
  sudo apt install --no-install-recommends lxqt-taskmanager
  
  # Install LXQt Archiver (archive manager for LXQt)
  sudo apt install --no-install-recommends lxqt-archiver
  
  # Install LXQt Qlipper (clipboard manager)
  sudo apt install --no-install-recommends qlipper
  
  # Install LXQt Power Management (power management tools)
  sudo apt install --no-install-recommends lxqt-powermanagement
  
  # Install Papirus Icon Theme (icon theme)
  sudo apt install --no-install-recommends papirus-icon-theme
  
  # Install LXQt Notification Daemon (notification manager)
  sudo apt install --no-install-recommends lxqt-notificationd
  
  # Install LXQt PolicyKit Agent (PolicyKit authentication agent)
  sudo apt install --no-install-recommends lxqt-policykit
  
  # Install FeatherPad (lightweight Qt text editor)
  sudo apt install --no-install-recommends featherpad
  
  # Install Firefox (web browser)
  sudo apt install --no-install-recommends firefox
  
  # Install KeePassXC (password manager using Qt)
  sudo apt install --no-install-recommends keepassxc
  
  # Install Thunderbird (email client)
  sudo apt install --no-install-recommends thunderbird
  
  # Install LibreOffice (office suite)
  sudo apt install --no-install-recommends libreoffice
  
  # Install LXImage-Qt (image viewer for LXQt)
  sudo apt install --no-install-recommends lximage-qt
  
  # Install LXQt Screenshot Tool (screenshot tool for LXQt)
  sudo apt install --no-install-recommends lxqt-screenshot
  
  # Install LXMusic (minimalistic music player for LXQt)
  sudo apt install --no-install-recommends lxmusic
  
  # Install VLC (multimedia player)
  sudo apt install --no-install-recommends vlc
  
  # Install KCalc (calculator for KDE, lightweight and Qt-based)
  sudo apt install --no-install-recommends kcalc
  
  # Install LXQt Configuration Center (configuration tools)
  sudo apt install --no-install-recommends lxqt-config
  
  # Install LXQt Admin (system administration tools)
  sudo apt install --no-install-recommends lxqt-admin
  </code></pre>

  <h4>Alternatives</h4>

  <p>Instead of <code>xfwm4</code>, you can use another window manager. Here are some alternatives:</p>

  <ul>
      <li><code>openbox</code></li>
      <li><code>fluxbox</code></li>
  </ul>

  <p>Instead of <code>sddm</code>, you can use another display manager. Here are some alternatives:</p>

  <ul>
      <li><code>lightdm</code> (Lightweight Display Manager)</li>
      <li><code>sdm</code> (Simple Desktop Display Manager)</li>
      <li><code>gdm3</code> (GNOME Display Manager)</li>
  </ul>

  <pre><code>
  # Example of using openbox for window manager and lightdm for display manager
  sudo apt install --no-install-recommends openbox lightdm
  sudo systemctl enable lightdm
  </code></pre>

  <h4>Minimal GNOME</h4>

  <pre><code>
  # Install Intel graphics drivers (optional, replace with appropriate driver for your hardware)
  sudo apt install --no-install-recommends xserver-xorg-video-intel
  # Install AMD graphics drivers (optional, replace with appropriate driver for your hardware)
  sudo apt install --no-install-recommends xserver-xorg-video-amdgpu
  
  # Install input driver
  sudo apt install --no-install-recommends xserver-xorg-input-libinput
  
  # Install GNOME session
  sudo apt install --no-install-recommends gnome-session
  
  # Install cursor themes
  sudo apt install --no-install-recommends xcursor-themes
  
  # Install DHCP client (optional)
  sudo apt install --no-install-recommends dhcpcd5
  
  # Install GNOME Display Manager (GDM)
  sudo apt install --no-install-recommends gdm3
  
  # Enable GDM and DHCP service
  sudo systemctl enable gdm3
  sudo systemctl enable dhcpcd
  </code></pre>

  <h5>GNOME Optional</h5>

  <pre><code>
  # Install GNOME Terminal (terminal emulator)
  sudo apt install --no-install-recommends gnome-terminal
  
  # Install Nautilus (file manager)
  sudo apt install --no-install-recommends nautilus
  
  # Install PulseAudio (sound server)
  sudo apt install --no-install-recommends pulseaudio
  
  # Install Pavucontrol (PulseAudio volume control)
  sudo apt install --no-install-recommends pavucontrol
  
  # Install Mesa graphics drivers
  sudo apt install --no-install-recommends libgl1-mesa-dri
  
  # Install X11 utilities
  sudo apt install --no-install-recommends x11-xserver-utils
  
  # Install GNOME themes
  sudo apt install --no-install-recommends gnome-themes
  
  # Install GNOME Control Center (system settings)
  sudo apt install --no-install-recommends gnome-control-center
  
  # Install GNOME icon theme
  sudo apt install --no-install-recommends gnome-icon-theme
  
  # Install GNOME Software (software center)
  sudo apt install --no-install-recommends gnome-software
  
  # Install Papirus Icon Theme (icon theme)
  sudo apt install --no-install-recommends papirus-icon-theme
  </code></pre>

  <h3>Others</h3>

  <h4>Minimal Environment with Polybar and Openbox</h4>

  <p><a href="https://github.com/polybar/polybar">Polybar - Status bar</a></p>
  <p><a href="https://github.com/danakj/openbox">Openbox - Window Manager (OpenboxWM)</a></p>
  <p><a href="https://i3wm.org/">i3wm - Window Manager</a></p>
  <p><a href="https://wiki.archlinux.org/index.php/Bspwm">Bspwm - Window Manager</a></p>
  <p><a href="https://invisible-island.net/xterm">Xterm - Terminal emulator for the X Window System</a></p>
  <p><a href="https://invisible-island.net/xterm">Urxvt - Terminal emulator</a></p>

  <p>To create a minimalistic environment with Polybar and Openbox, follow the steps below:</p>

  <h5>Install Dependencies</h5>

  <pre><code>
  # Update packages and install necessary dependencies
  sudo apt update
  sudo apt install build-essential cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev \
  libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev \
  pkg-config python-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound-dev libmpdclient-dev \
  libiw-dev libcurl4-openssl-dev libpulse-dev libjsoncpp-dev libxcb-composite0-dev llvm clang ccache \
  libnl-3-dev xterm
  </code></pre>

  <h4>Install Openbox</h4>

  <pre><code>
  # Install Openbox and its utilities
  sudo apt install openbox obconf
  # Install a terminal emulator, such as xterm
  sudo apt install xterm
  </code></pre>

  <h4>Install Polybar</h4>

  <pre><code>
  # Clone the Polybar repository and build
  git clone https://github.com/polybar/polybar.git
  cd polybar && ./build.sh
  # Copy the example configuration file
  mkdir -p ~/.config/polybar
  cp /usr/local/share/doc/polybar/config ~/.config/polybar/config

  chmod +x ~/.config/polybar/launch.sh
  </code></pre>

  <h4>Configure Openbox to Start Polybar</h4>

  <pre><code>
  # Create the Openbox autostart file if it doesn't exist
  mkdir -p ~/.config/openbox
  nano ~/.config/openbox/autostart
  # Add the following line to start Polybar
  polybar example &
  # Add xterm to start automatically
  xterm &
  </code></pre>

  <h4>Start the Environment</h4>

  <pre><code>
  # To start the environment, you can use startx or create a .xinitrc file
  nano ~/.xinitrc
  # Add the following lines to .xinitrc
  exec openbox-session
  # Save and close the file. Now, start the environment with:
  startx
  </code></pre>

  <h4>Optional Configurations</h4>

  <p>You can install and configure additional utilities to enhance your environment:</p>

  <ul>
      <li><code>lxappearance</code> - Tool to configure GTK themes.</li>
      <li><code>obmenu</code> - Openbox menu editor.</li>
      <li><code>feh</code> - Set wallpaper.</li>
      <li><code>compton</code> - Window compositor for transparency effects.</li>
  </ul>

  <h5>Installation of Optional Utilities</h5>

  <pre><code>
  sudo apt install lxappearance obmenu feh compton
  # Example: Configure feh in Openbox autostart to set wallpaper
  echo "feh --bg-scale /path/to/your/image.jpg &" >> ~/.config/openbox/autostart
  # Example: Configure compton in Openbox autostart
  echo "compton &" >> ~/.config/openbox/autostart
  </code></pre>

  <h4>Polybar and Papirus Icon Theme Optional</h4>

  <pre><code>
  # Install the Papirus Icon Theme
  sudo apt install papirus-icon-theme
  # Add Papirus Icon Theme to lxappearance to select icons
  lxappearance
  </code></pre>

  <h4>Polybar with i3-wm and Dependencies</h4>

  <p>If you prefer to use Polybar with i3-wm, install the following dependencies:</p>

  <pre><code>
  sudo apt install build-essential cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev \
  libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev \
  pkg-config python-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound-dev libmpdclient-dev \
  libiw-dev libcurl4-openssl-dev libpulse-dev libjsoncpp-dev libxcb-composite0-dev llvm clang ccache libnl-3-dev -yy
  </code></pre>

  <h4>Finalizing</h4>
  
  <p>It's possible to exit chroot to finalize the installation now and then reboot, or continue with the installation of the environment.</p>

  <p>Exit the chroot environment and unmount filesystems:</p>

  <pre><code>
  apt clean
  exit
  umount -R /mnt
  cryptsetup close sda2_crypt
  </code></pre>

  <p>Reboot your system:</p>

  <pre><code>
  reboot
  </code></pre>

  <p>After rebooting, Debian GNU/Linux with encrypted LVM should be installed and ready to use.</p>

  <h4>Other References</h4>
  
  <ul>
  <li><a href="https://wiki.debian.org/Debootstrap">https://wiki.debian.org/Debootstrap</a></li>
  <li><a href="https://wiki.ubuntu.com/DebootstrapChroot">https://wiki.ubuntu.com/DebootstrapChroot</a></li>
  <li><a href="https://wiki.debian.org/DebianInstall">https://wiki.debian.org/DebianInstall</a></li>
  <li><a href="https://www.debian.org/releases/stable/amd64/">https://www.debian.org/releases/stable/amd64/</a></li>
  <li><a href="https://help.ubuntu.com/community/ManualFullSystemEncryption/OverviewPartitionPreparation">https://help.ubuntu.com/community/ManualFullSystemEncryption/OverviewPartitionPreparation</a></li>
  <li><a href="https://wiki.archlinux.org/title/dm-crypt/Encrypting_an_entire_system">https://wiki.archlinux.org/title/dm-crypt/Encrypting_an_entire_system</a></li>
  <li><a href="https://wiki.archlinux.org/title/Partitioning">https://wiki.archlinux.org/title/Partitioning</a></li>
  <li><a href="https://gist.github.com/varqox/42e213b6b2dde2b636ef">https://gist.github.com/varqox/42e213b6b2dde2b636ef</a></li>
  <li><a href="https://github.com/AlexisMtzGasca/Debootstrap">https://github.com/AlexisMtzGasca/Debootstrap</a></li>
  <li><a href="https://gitlab.com/cryptsetup/cryptsetup">https://gitlab.com/cryptsetup/cryptsetup</a></li>
  <li><a href="https://wiki.archlinux.org/title/Dm-crypt">https://wiki.archlinux.org/title/Dm-crypt</a></li>
  <li><a href="https://manpages.debian.org/bookworm/mount/fstab.5.en.html">https://manpages.debian.org/bookworm/mount/fstab.5.en.html</a></li>
  <li><a href="https://manpages.debian.org/bookworm/cryptsetup/crypttab.5.en.html">https://manpages.debian.org/bookworm/cryptsetup/crypttab.5.en.html</a></li>
  </ul>

  </body>
</html>
