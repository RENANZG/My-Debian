<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>KVM/QEMU Security</title>
<style>
  body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    margin: 20px;
    background-color: #f5f5f5;
  }
  
  h1 {
    text-align: center;
    color: #000000;
  }
  
  table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
  }
  
  th,
  td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: center;
  }
  
  th {
    background-color: #f9f9f9;
    color: #000000;
  }
  
  tr:nth-child(even) {
    background-color: #f2f2f2;
  }
  
  a {
    color: #0056b3;
    text-decoration: none;
  }
</style>
</head>

<body>
  <h1>KVM/QEMU Security</h1>
  <h2>Architecture</h2>
  <p>The architecture consists of three main
    components:</p>
  <ul>
    <li>KVM (in-kernel)
      <ul>
        <li>kvm.ko</li>
        <li>kvm-{amd,intel}.ko</li>
      </ul>
    </li>
    <li>QEMU (userspace)
      <ul>
        <li>qemu-kvm</li>
      </ul>
    </li>
  </ul>
  <p>kvm.ko implements the virtual CPU and MMU
    and emulates some devices in-kernel for
    efficiency. kvm-{amd,intel}.ko provides
    support for Intel VMX and AMD SVM virtualization
    extensions. qemu-kvm implements most
    of the virtual devices used by a VM.</p>

  <h2>Previous QEMU/KVM VM Escapes (CVEs)</h2>

  <table>
    <thead>
      <tr>
        <th>CVE ID</th>
        <th>Description</th>
        <th>Max CVSS</th>
        <th>EPSS Score</th>
        <th>Published</th>
        <th>Updated</th>
        <th>Source</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2024-24474</a></td>
        <td>QEMU before 8.2.0 has an integer
          underflow, and resultant buffer
          overflow, via a TI command when
          an expected non-DMA transfer length
          is less than the length of the
          available FIFO data. This occurs
          in esp_do_nodma in hw/scsi/esp.c
          because of an underflow of async_len.</td>
        <td>N/A</td>
        <td>0.05%</td>
        <td>2024-02-20</td>
        <td>2024-06-10</td>
        <td>MITRE</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2024-4467</a></td>
        <td>A flaw was found in the QEMU disk
          image utility (qemu-img) 'info'
          command. A specially crafted image
          file containing a <code>json:{}</code>
          value describing block devices
          in QMP could cause the qemu-img
          process on the host to consume
          large amounts of memory or CPU
          time, leading to denial of service
          or read/write to an existing external
          file.</td>
        <td>7.8</td>
        <td>0.05%</td>
        <td>2024-07-02</td>
        <td>2024-07-03</td>
        <td>Red Hat, Inc.</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2024-3567</a></td>
        <td>A flaw was found in QEMU. An assertion
          failure was present in the update_sctp_checksum()
          function in hw/net/net_tx_pkt.c
          when trying to calculate the checksum
          of a short-sized fragmented packet.
          This flaw allows a malicious guest
          to crash QEMU and cause a denial
          of service condition.</td>
        <td>5.5</td>
        <td>0.04%</td>
        <td>2024-04-10</td>
        <td>2024-06-10</td>
        <td>Red Hat, Inc.</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2024-3446</a></td>
        <td>A double free vulnerability was found
          in QEMU virtio devices (virtio-gpu,
          virtio-serial-bus, virtio-crypto),
          where the mem_reentrancy_guard
          flag insufficiently protects against
          DMA reentrancy issues. This issue
          could allow a malicious privileged
          guest user to crash the QEMU process
          on the host, resulting in a denial
          of service or allow arbitrary code
          execution within the context of
          the QEMU process on the host.</td>
        <td>8.2</td>
        <td>0.05%</td>
        <td>2024-04-09</td>
        <td>2024-04-18</td>
        <td>Red Hat, Inc.</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2023-42467</a></td>
        <td>QEMU through 8.0.0 could trigger
          a division by zero in scsi_disk_reset
          in hw/scsi/scsi-disk.c because
          scsi_disk_emulate_mode_select does
          not prevent s-&gt;qdev.blocksize
          from being 256. This stops QEMU
          and the guest immediately.</td>
        <td>5.5</td>
        <td>0.04%</td>
        <td>2023-09-11</td>
        <td>2023-11-04</td>
        <td>MITRE</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2023-40360</a></td>
        <td>QEMU through 8.0.4 accesses a NULL
          pointer in nvme_directive_receive
          in hw/nvme/ctrl.c because there
          is no check for whether an endurance
          group is configured before checking
          whether Flexible Data Placement
          is enabled.</td>
        <td>5.5</td>
        <td>0.05%</td>
        <td>2023-08-14</td>
        <td>2023-12-11</td>
        <td>MITRE</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2023-6693</a></td>
        <td>A stack based buffer overflow was
          found in the virtio-net device
          of QEMU. This issue occurs when
          flushing TX in the virtio_net_flush_tx
          function if guest features VIRTIO_NET_F_HASH_REPORT,
          VIRTIO_F_VERSION_1 and VIRTIO_NET_F_MRG_RXBUF
          are enabled. This could allow a
          malicious user to overwrite local
          variables allocated on the stack.
          Specifically, the <code>out_sg</code>
          variable could be used to read
          a part of process memory and send
          it to the wire, causing an information
          leak.</td>
        <td>5.3</td>
        <td>0.05%</td>
        <td>2024-01-02</td>
        <td>2024-05-22</td>
        <td>Red Hat, Inc.</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2023-6683</a></td>
        <td>A flaw was found in the QEMU built-in
          VNC server while processing ClientCutText
          messages. The qemu_clipboard_request()
          function can be reached before
          vnc_server_cut_text_caps() was
          called and had the chance to initialize
          the clipboard peer, leading to
          a NULL pointer dereference. This
          could allow a malicious authenticated
          VNC client to crash QEMU and trigger
          a denial of service.</td>
        <td>6.5</td>
        <td>0.05%</td>
        <td>2024-01-12</td>
        <td>2024-05-22</td>
        <td>Red Hat, Inc.</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2023-5088</a></td>
        <td>A bug in QEMU could cause a guest
          I/O operation otherwise addressed
          to an arbitrary disk offset to
          be targeted to offset 0 instead
          (potentially overwriting the VM's
          boot code). This could be used,
          for example, by L2 guests with
          a virtual disk (vdiskL2) stored
          on a virtual disk of an L1 (vdiskL1)
          hypervisor to read and/or write
          data to LBA 0 of vdiskL1, potentially
          gaining control of L1 at its next
          reboot.</td>
        <td>7.0</td>
        <td>0.04%</td>
        <td>2023-11-03</td>
        <td>2024-05-22</td>
        <td>Red Hat, Inc.</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2023-4135</a></td>
        <td>A heap out-of-bounds memory read
          flaw was found in the virtual nvme
          device in QEMU. The QEMU process
          does not validate an offset provided
          by the guest before computing a
          host heap pointer, which is used
          for copying data back to the guest.
          Arbitrary heap memory relative
          to an allocated buffer can be disclosed.</td>
        <td>6.5</td>
        <td>0.05%</td>
        <td>2023-08-04</td>
        <td>2023-12-11</td>
        <td>Red Hat, Inc.</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2023-3354</a></td>
        <td>A flaw was found in the QEMU built-in
          VNC server. When a client connects
          to the VNC server, QEMU checks
          whether the current number of connections
          crosses a certain threshold and
          if so, cleans up the previous connection.
          If the previous connection happens
          to be in the handshake phase and
          fails, QEMU cleans up the connection
          again, resulting in a NULL pointer
          dereference issue. This could allow
          a remote unauthenticated client
          to cause a denial of service.</td>
        <td>7.5</td>
        <td>0.05%</td>
        <td>2023-07-11</td>
        <td>2024-03-11</td>
        <td>Red Hat, Inc.</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2023-3301</a></td>
        <td>A flaw was found in QEMU. The async
          nature of hot-unplug enables a
          race scenario where the net device
          backend is cleared before the virtio-net
          pci frontend has been unplugged.
          A malicious guest could use this
          time window to trigger an assertion
          and cause a denial of service.</td>
        <td>5.6</td>
        <td>0.04%</td>
        <td>2023-09-13</td>
        <td>2023-11-04</td>
        <td>Red Hat, Inc.</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2023-3255</a></td>
        <td>A flaw was found in the QEMU built-in
          VNC server while processing ClientCutText
          messages. A wrong exit condition
          may lead to an infinite loop when
          inflating an attacker controlled
          zlib buffer in the <code>inflate_buffer</code>
          function. This could allow a remote
          authenticated client who is able
          to send a clipboard to the VNC
          server to trigger a denial of service.</td>
        <td>6.5</td>
        <td>0.16%</td>
        <td>2023-09-13</td>
        <td>2024-05-22</td>
        <td>Red Hat, Inc.</td>
      </tr>
      <tr>
        <td><a rel="noreferrer" target="_new">CVE-2023-3180</a></td>
        <td>A flaw was found in the QEMU virtual
          crypto device while handling data
          encryption/decryption requests
          in virtio_crypto_handle_sym_req.
          There is no check for the value
          of <code>src_len</code> and <code>dst_len</code>
          in virtio_crypto_sym_op_helper,
          potentially leading to a heap buffer
          overflow when the two values differ.</td>
        <td>6.5</td>
        <td>0.04%</td>
        <td>2023-08-03</td>
        <td>2023-10-13</td>
        <td>Red Hat, Inc.</td>
      </tr>
    </tbody>
  </table>

  <table>
    <thead>
      <tr>
        <th>CVE ID</th>
        <th>Description</th>
        <th>Source</th>
        <th>Max CVSS</th>
        <th>EPSS Score</th>
        <th>Published</th>
        <th>Updated</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><strong>CVE-2022-0216</strong></td>
        <td>A use-after-free vulnerability was
          found in the LSI53C895A SCSI Host
          Bus Adapter emulation of QEMU.
          The flaw occurs while processing
          repeated messages to cancel the
          current SCSI request via the lsi_do_msgout
          function. This flaw allows a malicious
          privileged user within the guest
          to crash the QEMU process on the
          host, resulting in a denial of
          service.</td>
        <td>Red Hat, Inc.</td>
        <td>4.4</td>
        <td>0.08%</td>
        <td>2022-08-26</td>
        <td>2023-02-12</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-20295</strong></td>
        <td>It was discovered that the update
          for the virt
          <div></div>module in the RHSA-2020:4676
          (<a href="noreferrer" target="_new"
          href="https://access.redhat.com/errata/RHSA-2020:4676">
          https://access.redhat.com/errata/RHSA-2020:4676</a>)
          erratum released as part of Red
          Hat Enterprise Linux 8.3 failed
          to include the fix for the qemu-kvm
          component issue CVE-2020-10756.
          CVE-2021-20295 was assigned to
          that Red Hat specific security
          regression.</td>
        <td>Red Hat, Inc.</td>
        <td>6.5</td>
        <td>0.05%</td>
        <td>2022-04-01</td>
        <td>2022-10-06</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-20263</strong></td>
        <td>A flaw was found in the virtio-fs
          shared file system daemon (virtiofsd)
          of QEMU. The new 'xattrmap' option
          may cause the 'security.capability'
          xattr in the guest to not drop
          on file write, potentially leading
          to a modified, privileged executable
          in the guest. In rare circumstances,
          this flaw could be used by a malicious
          user to elevate their privileges
          within the guest.</td>
        <td>Red Hat, Inc.</td>
        <td>3.3</td>
        <td>0.05%</td>
        <td>2021-03-09</td>
        <td>2022-09-30</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-20257</strong></td>
        <td>An infinite loop flaw was found in
          the e1000 NIC emulator of the QEMU.
          This issue occurs while processing
          transmits (tx) descriptors in process_tx_desc
          if various descriptor fields are
          initialized with invalid values.
          This flaw allows a guest to consume
          CPU cycles on the host, resulting
          in a denial of service.</td>
        <td>Red Hat, Inc.</td>
        <td>6.5</td>
        <td>0.05%</td>
        <td>2022-03-16</td>
        <td>2023-02-12</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-20255</strong></td>
        <td>A stack overflow via an infinite
          recursion vulnerability was found
          in the eepro100 i8255x device emulator
          of QEMU. This issue occurs while
          processing controller commands
          due to a DMA reentry issue. This
          flaw allows a guest user or process
          to consume CPU cycles or crash
          the QEMU process on the host, resulting
          in a denial of service.</td>
        <td>Red Hat, Inc.</td>
        <td>5.5</td>
        <td>0.05%</td>
        <td>2021-03-09</td>
        <td>2022-08-05</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-20221</strong></td>
        <td>An out-of-bounds heap buffer access
          issue was found in the ARM Generic
          Interrupt Controller emulator of
          QEMU up to and including qemu 4.2.0
          on aarch64 platform. The issue
          occurs because while writing an
          interrupt ID to the controller
          memory area, it is not masked to
          be 4 bits wide. It may lead to
          the said issue while updating controller
          state fields and their subsequent
          processing. A privileged guest
          user may use this flaw to crash
          the QEMU process on the host resulting
          in DoS scenario.</td>
        <td>Red Hat, Inc.</td>
        <td>6.0</td>
        <td>0.05%</td>
        <td>2021-05-13</td>
        <td>2023-02-12</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-20203</strong></td>
        <td>An integer overflow issue was found
          in the vmxnet3 NIC emulator of
          the QEMU for versions up to v5.2.0.
          It may occur if a guest was to
          supply invalid values for rx/tx
          queue size or other NIC parameters.
          A privileged guest user may use
          this flaw to crash the QEMU process
          on the host resulting in DoS scenario.</td>
        <td>Red Hat, Inc.</td>
        <td>3.2</td>
        <td>0.06%</td>
        <td>2021-02-25</td>
        <td>2022-09-30</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-20196</strong></td>
        <td>A NULL pointer dereference flaw was
          found in the floppy disk emulator
          of QEMU. This issue occurs while
          processing read/write ioport commands
          if the selected floppy drive is
          not initialized with a block device.
          This flaw allows a privileged guest
          user to crash the QEMU process
          on the host, resulting in a denial
          of service.</td>
        <td>Red Hat, Inc.</td>
        <td>6.5</td>
        <td>0.06%</td>
        <td>2021-05-26</td>
        <td>2023-02-12</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-20181</strong></td>
        <td>A race condition flaw was found in
          the 9pfs server implementation
          of QEMU up to and including 5.2.0.
          This flaw allows a malicious 9p
          client to cause a use-after-free
          error, potentially escalating their
          privileges on the system. The highest
          threat from this vulnerability
          is to confidentiality, integrity
          as well as system availability.</td>
        <td>Red Hat, Inc.</td>
        <td>7.5</td>
        <td>0.05%</td>
        <td>2021-05-13</td>
        <td>2022-09-30</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-4207</strong></td>
        <td>A flaw was found in the QXL display
          device emulation in QEMU. A double
          fetch of guest controlled values
          <code>cursor-&gt;header.width</code>
          and <code>cursor-&gt;header.height</code>
          can lead to the allocation of a
          small cursor object followed by
          a subsequent heap-based buffer
          overflow. A malicious privileged
          guest user could use this flaw
          to crash the QEMU process on the
          host or potentially execute arbitrary
          code within the context of the
          QEMU process.</td>
        <td>Red Hat, Inc.</td>
        <td>8.2</td>
        <td>0.07%</td>
        <td>2022-04-29</td>
        <td>2022-11-29</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-4206</strong></td>
        <td>A flaw was found in the QXL display
          device emulation in QEMU. An integer
          overflow in the cursor_alloc()
          function can lead to the allocation
          of a small cursor object followed
          by a subsequent heap-based buffer
          overflow. This flaw allows a malicious
          privileged guest user to crash
          the QEMU process on the host or
          potentially execute arbitrary code
          within the context of the QEMU
          process.</td>
        <td>Red Hat, Inc.</td>
        <td>8.2</td>
        <td>0.05%</td>
        <td>2022-04-29</td>
        <td>2022-09-23</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-4158</strong></td>
        <td>A NULL pointer dereference issue
          was found in the ACPI code of QEMU.
          A malicious, privileged user within
          the guest could use this flaw to
          crash the QEMU process on the host,
          resulting in a denial of service
          condition.</td>
        <td>Red Hat, Inc.</td>
        <td>6.0</td>
        <td>0.08%</td>
        <td>2022-08-24</td>
        <td>2024-01-25</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-4145</strong></td>
        <td>A NULL pointer dereference issue
          was found in the block mirror layer
          of QEMU in versions prior to 6.2.0.
          The <code>self</code> pointer is
          dereferenced in mirror_wait_on_conflicts()
          without ensuring that it's not
          NULL. A malicious unprivileged
          user within the guest could use
          this flaw to crash the QEMU process
          on the host when writing data reaches
          the threshold of mirroring node.</td>
        <td>Red Hat, Inc.</td>
        <td>6.5</td>
        <td>0.04%</td>
        <td>2022-01-25</td>
        <td>2022-09-28</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-3947</strong></td>
        <td>A stack-buffer-overflow was found
          in QEMU in the NVME component.
          The flaw lies in nvme_changed_nslist()
          where a malicious guest controlling
          certain input can read out of bounds
          memory. A malicious user could
          use this flaw leading to disclosure
          of sensitive information.</td>
        <td>Red Hat, Inc.</td>
        <td>5.5</td>
        <td>0.05%</td>
        <td>2022-02-18</td>
        <td>2023-11-21</td>
      </tr>
      <tr>
        <td><strong>CVE-2021-3930</strong></td>
        <td>An off-by-one error was found in
          the SCSI device emulation in QEMU.
          It could occur while processing
          MODE SELECT commands in mode_sense_page()
          if the 'page' argument was set
          to MODE_PAGE_ALLS (0x3f). A malicious
          guest could use this flaw to potentially
          crash QEMU, resulting in a denial
          of service condition.</td>
        <td>Red Hat, Inc.</td>
        <td>6.5</td>
        <td>0.05%</td>
        <td>2022-02-18</td>
        <td>2022-10-06</td>
      </tr>
    </tbody>
  </table>

  <p><a href="https://www.cvedetails.com/vendor/7506/Qemu.html">CVE Details - Qemu</a></p>

  <h2>Mitigations</h2>
  <p>Consider the following mitigations for
    improving KVM/QEMU security:</p>
  <ul>
    <li><strong>For KVM Vulnerabilities:</strong>
      No specific mitigations available;
      the entire host is compromised.</li>
    <li><strong>For QEMU Vulnerabilities:</strong>
      <ul>
        <li>Run QEMU as an unprivileged user.</li>
        <li>Apply sandboxing techniques:
          <ul>
            <li>Use <code>seccomp</code> to restrict
              system calls.</li>
            <li>Implement Mandatory Access Control
              (MAC) using tools like SELinux
              or AppArmor.</li>
          </ul>
        </li>
        <li>Regularly update QEMU and related
          components to the latest versions.</li>
        <li>Perform security audits and vulnerability
          assessments regularly.</li>
      </ul>
    </li>
  </ul>

  <h2>Additional Resources</h2>
  <p>Explore these resources for further understanding
    and security practices:</p>
  <ul>
    <li><a href="https://www.youtube.com/watch?v=YAdRf_hwxU8">
    Security in QEMU: How Virtual Machines Provide Isolation by Stefan Hajnoczi</a></li>
    <li><a href="https://www.youtube.com/watch?v=_7yGiafZdVc">
    Eduardo Otubo: Qemu Sandboxing for dummies</a></li>
  </ul>

  <p>For detailed implementation of <code>seccomp</code>,
    add <code>--sandbox on</code> to the
    QEMU command line. Check AppArmor status
    using <code>aa-enabled</code> and <code>aa-status</code>.</p>
  <p>By default, libvirt should implement most
    security mitigations.</p>
</body>

</html>
