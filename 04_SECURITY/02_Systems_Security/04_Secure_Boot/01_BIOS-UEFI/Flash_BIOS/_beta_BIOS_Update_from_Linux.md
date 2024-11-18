<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Updating BIOS Using FreeDOS from Linux</title>
<style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
    }
    .container {
      max-width: 800px;
      margin: auto;
      padding: 20px;
    }
    h1, h2, h3 {
      color: #333;
    }
    pre {
      background: #f4f4f4;
      padding: 10px;
      border: 1px solid #ddd;
      overflow-x: auto;
    }
    a {
      color: #0066cc;
    }
</style>
</head>
<body>
<div class="container">

  <h1>Updating BIOS Using FreeDOS from Linux</h1>

  <p>Updating your BIOS can be a critical process for maintaining the stability
    and performance of your system. However, for Linux users, the process
    can be challenging, especially when the BIOS update is only available
    as a Windows PE executable. This tutorial will guide you through updating
    a Lenovo BIOS using FreeDOS from Linux. Please note that unofficial
    methods can pose greater risks to your system.</p>

  <h3>Disclaimer</h3>

  <p>Updating BIOS carries risks, including potential bricking of your system.
    Proceed with caution and at your own risk.</p>

  <h2>Prerequisites</h2>

  <ul>
    <li>FreeDOS: <a href="https://www.freedos.org/">freedos.org</a> (¹)</li>
    <li>USB stick (at least 4GB)</li>
    <li>BIOS update executable from Lenovo</li>
    <li>Linux machine</li>
  </ul>

  <h2>Step 1: Check Your Current BIOS Version</h2>

  <p>Before proceeding, ensure you have noted your current BIOS version. You
    can use the <code>dmidecode</code> command to check this:</p>

  <pre><code>sudo dmidecode -s bios-version</code></pre>

  <p>If you're updating the BIOS on another computer, you can check the BIOS
    version by pressing <code>F2</code> (or the appropriate key) during
    boot or by checking the product serial number on the manufacturer's
    support site.</p>

  <h2>Step 2: Create a Bootable FreeDOS USB Stick</h2>

  <p>First, we need to create a bootable FreeDOS USB stick. This will allow
    us to boot into FreeDOS and run the BIOS update.</p>

<pre><code>
# Install necessary tools
sudo apt-get install dosfstools
# Download FreeDOS image
wget https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.2/FD12FULL.zip
# Extract the FreeDOS image
unzip FD12FULL.zip -d freedos
# Create a bootable USB
sudo dd if=freedos/FD12FULL.img of=/dev/sdX bs=4M
sync
</code></pre>

  <p>Replace <code>/dev/sdX</code> with your actual USB device. Be very careful
    with this step to avoid overwriting important data on your system.
  </p>

  <h2>Step 3: Extract the BIOS Update</h2>

  <p>The BIOS update from Lenovo is usually provided as a Windows executable.
    We need to extract the BIOS update files (which are not always <code>*.BIN</code>    files; they can vary) from this executable. You can use <code>innoextract</code>    or
    <code>cabextract</code> for this purpose.</p>

<pre><code>
# Install cabextract
sudo apt-get install cabextract
# Extract the BIOS update file
cabextract biosupdate.exe
</code></pre>

  <h2>Step 4: Copy the BIOS Update Files to USB</h2>

  <p>Next, copy the extracted BIOS update files to your FreeDOS USB stick.
    When copying the files, you may be prompted to replace existing files,
    such as <code>AUTOEXEC.BAT</code>. You should replace the file in the
    destination, as this will execute the command to launch the flash utility,
    which actually writes the firmware to the device.</p>

  <pre><code>
# Mount the USB stick
sudo mount /dev/sdX1 /mnt
# Copy the BIOS update files
sudo cp * /mnt
# Unmount the USB stick
sudo umount /mnt
</code></pre>

  <h2>Step 5: Boot into FreeDOS and Update the BIOS</h2>

  <p>Now, boot your system from the FreeDOS USB stick. You may need to change
    the boot order in your BIOS settings to do this. Once booted into FreeDOS,
    the <code>AUTOEXEC.BAT</code> file will automatically execute the command
    to launch the flash utility and update your BIOS.</p>

  <pre><code>a:\> flashup BIOSUPDATE.BIN</code></pre>

  <h2>References</h2>

  <ul>
    <li><strong>FreeDOS:</strong></li>
    <ul>
      <li>FreeDOS: <a href="https://www.freedos.org/">freedos.org</a> (¹)</li>
      <li>Creating a FreeDOS Bootable USB Stick: <a href="https://feeding.cloud.geek.nz/posts/creating-freedos-bootable-usb-stick-to/">feeding.cloud.geek.nz</a>        (²)</li>
    </ul>
    <li><strong>BIOS Updates:</strong></li>
    <ul>
      <li>Intel Support: <a href="https://www.intel.com/content/www/us/en/support.html">intel.com</a>        (³)</li>
      <li>Lenovo System Update: <a href="https://support.lenovo.com/us/en/solutions/ht003029-lenovo-system-update-update-drivers-bios-and-applications">support.lenovo.com</a>        (4)</li>
      <li>Dell BIOS Updates: <a href="https://www.dell.com/support/home/en-us?app=drivers">Dell Support</a></li>
      <li>Dell BIOS Recovery: <a href="https://www.dell.com/support/kbdoc/en-us/000124211/forced-bios-update-or-bios-recovery-using-the-external-usb-device">Dell BIOS Recovery Guide</a></li>
      <li>BIOS Update Guide: <a href="https://www.pcworld.com/article/187437/how-to-update-your-bios.html">PC World Guide</a></li>
      <li>Lenovo BIOS Update: <a href="https://download.lenovo.com/pccbbs/mobiles/r07uj33d.exe">download.lenovo.com</a></li>
      <li>AFUDOS: <a href="https://ami.com/en/products/bios-uefi-tools-and-utilities/">ami.com</a></li>
    </ul>
    <li><strong>Tools and Utilities:</strong></li>
    <ul>
      <li>Flashrom: <a href="https://www.flashrom.org/">flashrom.org</a></li>
      <li>GNU ddrescue: <a href="https://www.gnu.org/software/ddrescue/">gnu.org/software/ddrescue</a></li>
      <li>BIOS Update Utility for Linux: <a href="https://fwupd.org/">fwupd.org</a></li>
      <li>Linux USB Creator: <a href="https://www.pendrivelinux.com/">Pendrive Linux</a></li>
      <li>Bootable USB Tools: <a href="https://www.balena.io/etcher/">Balena Etcher</a></li>
    </ul>
    <li><strong>BIOS Customization and Recovery:</strong></li>
    <ul>
      <li>BIOS Mods: <a href="https://www.bios-mods.com">bios-mods.com</a></li>
      <li>Replacing BIOS Chip: <a href="https://www.bios-chip24.com/epages/63730086.sf/en_GB/?ObjectPath=/Shops/63730086/Categories">bios-chip24.com</a></li>
      <li>BIOS Chip Replacement Tutorial: <a href="https://www.youtube.com/watch?v=lIz6Y1zW13M">YouTube Tutorial</a></li>
      <li>Coreboot: <a href="https://www.coreboot.org/">coreboot.org</a></li>
      <li>UEFI and BIOS Updates: <a href="https://wiki.archlinux.org/index.php/Flashing_BIOS_from_Linux">Arch Linux Wiki</a></li>
    </ul>
  </ul>

</div>

</body>
</html>