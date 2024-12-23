<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>How to Install and Setup Qemu/KVM on Debian 12</title>
<style>
  /* Generic style */
  body {
       font-family: Arial, sans-serif;
       line-height: 1.6;
       margin: 1em;
       max-width: 800px;
      /* Limit screen maximum width */
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
       text-align: justify;
      /* Justify text for better readability */
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
       white-space: pre-wrap;
      /* Wrap long lines in preformatted text */
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
           font-size: 16px;
          /* Decrease font size for better readability */
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
  <h2>How to Install and Setup Qemu/KVM on Debian 12</h2>

  <h3>Useful Links</h3>
  <ul>
    <li><a href="https://wiki.debian.org/KVM">Debian Wiki - KVM</a></li>
    <li><a href="https://wiki.archlinux.org/title/KVM">Arch Linux Wiki - KVM</a></li>
    <li><a href="https://wiki.qemu.org/Hosts/Linux#QEMU_on_Linux_hosts">Qemu on Linux Hosts</a></li>
    <li><a href="https://linux-kvm.org">Linux KVM</a></li>
    <li><a href="https://qemu.org">QEMU</a></li>
    <li><a href="https://libvirt.org">Libvirt</a></li>
    <li><a href="https://xenproject.org">Xen Project</a></li>
    <li><a href="https://cloud.debian.org/images/cloud/">Debian Official Cloud Images</a></li>
    <li><a href="https://www.whonix.org/wiki/KVM">Using Whonix with KVM</a></li>
  </ul>

  <h3>Hypervisor</h3>
  <p>KVM, or Kernel-based Virtual Machine, is a hypervisor built into the
    Linux kernel. It's a type 1 hypervisor that runs on bare metal, utilizing
    CPU extensions for virtualization.</p>

  <h3>Verify Hardware Support for VT-x/vmx/svm</h3>
  <pre>
        $ lscpu | grep Virtualization
        $ grep --color -iE 'vmx|svm' /proc/cpuinfo
    </pre>

  <h3>Install QEMU/KVM</h3>
  <pre>
        $ sudo apt install --no-install-recommends qemu-kvm qemu-system-x86 libvirt-daemon-system libvirt-clients virt-manager gir1.2-spiceclientgtk-3.0 dnsmasq qemu-utils iptables
    </pre>

  <h3>Add Your User to Group</h3>
  <p>To allow your user to manage virtual machines, add them to the necessary
    groups.</p>
  <pre>
        $ sudo adduser "$(whoami)" libvirt
        $ sudo adduser "$(whoami)" kvm
    </pre>
  <p>Note that a reboot is required after adding users to these groups.</p>
  <p>AppArmor could also block certain functionalities, so keep that in mind.</p>

  <h3>Cloud Image Settings</h3>
  <p>If you're working with cloud images, follow these steps:</p>
  <ol>
    <li>Copy the .qcow2 image to the appropriate folder:</li>
    <pre>
            $ sudo mv ~/Downloads/image.qcow2 /var/lib/libvirt/images
            or
            $ mkdir ~/cloud_images && cd ~/cloud_images
            $ wget https://cloud.debian.org/images/cloud/bookworm/20231210-1591/debian-12-generic-amd64-20231210-1591.qcow2
        </pre>
    <li>If you encounter "Permission Denied" errors, check if the directory
      exists and run commands from there. Avoid using chown; instead, add
      your username to the proper groups (kvm or libvirt).</li>
    <pre>
            $ sudo chown "$(whoami)" /dev/kvm
        </pre>
    <li>Verify:</li>
    <pre>
            $ ls -l /dev/kvm
        </pre>
  </ol>
  <p>Refer to the <a href="https://cloud.debian.org/images/cloud/">Debian Official Cloud Images</a>    and <a href="https://wiki.debian.org/ThomasChung/CloudImage">How to import Cloud Image</a>    for more information.</p>

  <h3>Set qcow2 Image Password</h3>
  <p>Here are the steps to set a password for your qcow2 image:</p>
  <ul>
    <li>Refer to the <a href="https://wiki.debian.org/ThomasChung/CloudImage#Reset_root_password_on_cloud_image">Debian Wiki</a>      for resetting the root password on a cloud image.</li>
    <li>Understand the default username for Debian cloud images by visiting
      <a href="https://wiki.debian.org/Cloud#What_is_the_default_user_name_on_the_Debian_cloud_images.3F">Debian Cloud Wiki</a>.</li>
  </ul>

  <h4>Virt-customize</h4>
  <pre>
        $ sudo apt install cloud-image-utils
        $ sudo virt-customize -v -a "your-qcow2-image" --root-password password: "your-password-here"
        $ sudo virt-customize -v -a ~/debian-12-generic-amd64-20231210-1591.qcow2 --root-password password: 123
    </pre>

  <h4>SSH Keypair</h4>
  <p>To use SSH public/private key login later, generate a keypair:</p>
  <pre>
        $ ssh-keygen -t rsa -b 4096 -f id_rsa -C test1 -N "" -q
    </pre>
  <p>This creates files named “id_rsa” and “id_rsa.pub”.</p>

  <h4>Cloud-init Configuration</h4>
  <p>Create a file named “cloud_init.cfg” with the below content:</p>
  <pre>
        #cloud-config
        hostname: test1
        fqdn: test1.example.com
        manage_etc_hosts: true
        users:
          - name: ubuntu
            sudo: ALL=(ALL) NOPASSWD:ALL
            groups: users, admin
            home: /home/ubuntu
            shell: /bin/bash
            lock_passwd: false
            ssh-authorized-keys:
              - &lt;sshPUBKEY&gt; &lt;Replace&gt;
        ssh_pwauth: false
        disable_root: false
        chpasswd:
          list: |
             ubuntu:linux
          expire: False
        package_update: true
        packages:
          - qemu-guest-agent
        final_message: "The system is finally up, after $UPTIME seconds"
    </pre>

  <h3>Launch (GUI)</h3>
  <p>To launch the Virtual Machine Manager GUI:</p>
  <pre>
        $ virt-manager
    </pre>
  <p>Go to Start Menu → Applications → System → Virtual Machine Manager, open
    your system, and click the play symbol to start the VM.</p>

  <h3>Launch (CLI)</h3>
  <p>For CLI-based launch:</p>
  <pre>
        $ virt-install --connect qemu:///system --memory memory=1024 --sysinfo emulate --vcpus 1 --cpu host --clock offset=utc --boot hd --network network=default,model=virtio --graphics spice --autoconsole graphical --video qxl --cdrom /var/lib/libvirt/images/debian-12.0.0-amd64-DVD-1.iso --name debian12-$(date +%Y%m%d-%H%M%S)-$$-$(printf '%04x' $RANDOM) --disk pool=default,size=5,bus=virtio,format=raw --osinfo name=debian12
    </pre>
  <p>Start the VM:</p>
  <pre>
        $ sudo virsh start Debian12-XXX
    </pre>
  <p>Ensure the virtual machine is given at least 1 GB of RAM and 1 processor
    core.</p>
  <p>You can also auto-resize the VM with the window options.</p>

  <h3>Notes</h3>
  <ul>
    <li>You can mount your qcow2 image under your host after converting it
      to raw and make changes, even in a chroot environment, before uploading
      it to your hypervisor.</li>
    <li>For encrypted containers or running KVM without X, additional steps
      may be required.</li>
    <li>Network settings can be managed using QEMU/KVM default networking and
      configuring the firewall as needed.</li>
  </ul>

  <h3>Uninstalling</h3>
  <h4>Cleaning</h4>
  <p>To remove QEMU/KVM and related packages:</p>
  <pre>
    $ sudo apt purge qemu-kvm qemu-system-x86 libvirt-daemon-system libvirt-clients virt-manager gir1.2-spiceclientgtk-3.0 dnsmasq qemu-utils
    $ sudo apt autoremove
</pre>
  <p>Remove configuration and user data:</p>
  <pre>
    $ sudo rm -rf /etc/libvirt
    $ sudo rm -rf ~/.config/dconf/user.d/virt-manager
    $ sudo rm -rf ~/.virt-manager
</pre>

</body>
</html>
