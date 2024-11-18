 <h3>Create a Virtual Machine with QEMU</h3>
  
  <pre><code>qemu-img create -f qcow2 debian.qcow2 20G</code></pre>

<p>Use QEMU to start the installation of Debian on the newly created disk image.</p>

  <pre><code>sudo qemu-system-x86_64 -m 2048 -boot d -drive file=debian.qcow2,format=qcow2 -cdrom debian.iso -enable-kvm</code></pre>


  <h3>Configure Networking</h3>

<p>By default, QEMU sets up a NAT network for your virtual machines. You can configure networking further using virt-manager or by editing QEMU network configuration files (/etc/libvirt/qemu/networks/default.xml).</p>
