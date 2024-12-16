  <!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Data-at-rest encryption</title>
<style>
  /* Generic style */
  body {
       font-family: Arial, sans-serif;
       margin: 0;
       padding: 20px;
       line-height: 1.6;
       max-width: 21cm; /* Limit screen maximum width */
       height: 29.7cm;
       margin-left: auto;
       margin-right: auto;
  }
   h1, h2, h3, h4, h5, h6 {
       font-weight: bold;
       margin-bottom: 0.5em;
   pre {
       background-color: #f4f4f4;
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
</style>
</head>
<body>

<p>Source:</p>
<a href="https://wiki.archlinux.org/title/Data-at-rest_encryption">https://wiki.archlinux.org/title/Data-at-rest_encryption</a>

<h3>Block device vs stacked filesystem encryption</h3>

<table border="1" class="wikitable left-align-row-headers" style="text-align:center;">
<tbody><tr>
<th>
</th>
<th>Block device encryption
</th>
<th>Stacked filesystem encryption
</th></tr>
<tr>
<th>Encrypts
</th>
<td>block devices
</td>
<td>files
</td></tr>
<tr>
<th>Container for encrypted data may be...
</th>
<td>a disk or disk partition / a file as loop device
</td>
<td>a directory in an existing file system
</td></tr>
<tr>
<th>Relation to filesystem
</th>
<td>operates below filesystem layer: does not care whether the content of the encrypted block device is a filesystem, a partition table, a LVM setup, or anything else
</td>
<td>adds an additional layer to an existing filesystem, to automatically encrypt/decrypt files whenever they are written/read
</td></tr>
<tr>
<th>Encrypts file metadata (number of files, directory structure, file sizes, permissions, modification times, etc.)
</th>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br>(Using 'discard' may reveal file sizes)
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">Partial<br>(Filenames are encrypted, other metadata may be visible depending on features)
</td></tr>
<tr>
<th>Can be used to custom-encrypt whole hard drives (including partition tables)
</th>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td></tr>
<tr>
<th>Can be used to encrypt swap space
</th>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td></tr>
<tr>
<th>Can be used without pre-allocating a fixed amount of space for the encrypted data container
</th>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No<br>(Using 'discard' may allow sparsely-allocated containers, at the cost of revealing file sizes)
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr>
<tr>
<th>Can be used to protect existing filesystems without block device access, e.g. NFS or Samba shares, cloud storage, etc.
</th>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No<sup>1</sup>
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr>
<tr>
<th>Allows offline file-based backups of encrypted files
</th>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr></tbody></table>

<h3>Data-at-rest encryption</h3>


<table border="1" class="wikitable left-align-row-headers" style="text-align:center; cell-padding:100px;">
<tbody><tr>
<th style="background: #ddd; color: inherit; vertical-align: middle; text-align: center;">Summary
</th>
<th>Loop-AES
</th>
<th><a href="/title/Dm-crypt" title="Dm-crypt">dm-crypt</a> +/- LUKS
</th>
<th><a href="/title/VeraCrypt" title="VeraCrypt">VeraCrypt</a>
</th>
<th><a href="/title/ZFS" title="ZFS">ZFS</a>
</th>
<th><a href="/title/ECryptfs" title="ECryptfs">eCryptfs</a>
</th>
<th><a href="/title/EncFS" title="EncFS">EncFS</a>
</th>
<th><a href="/title/Gocryptfs" title="Gocryptfs">gocryptfs</a>
</th>
<th><a href="/title/Fscrypt" title="Fscrypt">fscrypt</a>
</th></tr>
<tr>
<th>Encryption type
</th>
<td>block device
</td>
<td>block device
</td>
<td>block device
</td>
<td>native filesystem or block device
</td>
<td>stacked filesystem
</td>
<td>stacked filesystem
</td>
<td>stacked filesystem
</td>
<td>native filesystem
</td></tr>
<tr>
<th>Note
</th>
<td>longest-existing one; possibly the fastest; works on legacy systems
</td>
<td>de-facto standard for block device encryption on Linux; very flexible
</td>
<td>maintained fork of TrueCrypt, supporting TrueCrypt and VeraCrypt volumes
</td>
<td>encryption feature relatively new (2019); encrypted block devices provided by ZVOL
</td>
<td>slightly faster than EncFS; individual encrypted files portable between systems
</td>
<td>easiest one to use; supports non-root administration
</td>
<td>aspiring successor of EncFS
</td>
<td>default for Chrome OS and Android encryption
</td></tr>
<tr>
<th>Availability in Arch Linux
</th>
<td>requires manually compiled, custom kernel
</td>
<td><i>kernel modules:</i> already shipped with default kernel; <i>tools:</i> <span class="plainlinks archwiki-template-pkg"><a rel="nofollow" class="external text" href="https://archlinux.org/packages/?name=device-mapper">device-mapper</a></span>, <span class="plainlinks archwiki-template-pkg"><a rel="nofollow" class="external text" href="https://archlinux.org/packages/?name=cryptsetup">cryptsetup</a></span>
</td>
<td><span class="plainlinks archwiki-template-pkg"><a rel="nofollow" class="external text" href="https://archlinux.org/packages/?name=veracrypt">veracrypt</a></span>
</td>
<td><a href="/title/ZFS#Installation" title="ZFS">ZFS#Installation</a>
</td>
<td><i>kernel module:</i> already shipped with default kernel; <i>tools:</i> <span class="plainlinks archwiki-template-pkg"><a rel="nofollow" class="external text" href="https://archlinux.org/packages/?name=ecryptfs-utils">ecryptfs-utils</a></span>
</td>
<td><span class="plainlinks archwiki-template-pkg"><a rel="nofollow" class="external text" href="https://archlinux.org/packages/?name=encfs">encfs</a></span>
</td>
<td><span class="plainlinks archwiki-template-pkg"><a rel="nofollow" class="external text" href="https://archlinux.org/packages/?name=gocryptfs">gocryptfs</a></span>
</td>
<td><i>kernel module:</i> already shipped with default kernel; <i>tool:</i> <span class="plainlinks archwiki-template-pkg"><a rel="nofollow" class="external text" href="https://archlinux.org/packages/?name=fscrypt">fscrypt</a></span>
</td></tr>
<tr>
<th>License
</th>
<td>GPL
</td>
<td>GPL
</td>
<td>Apache License 2.0, parts subject to TrueCrypt License v3.0
</td>
<td>CDDL
</td>
<td>GPL
</td>
<td>GPL
</td>
<td>MIT
</td>
<td>GPL (kernel), Apache 2.0 (userspace tool)
</td></tr>
<tr>
<th>Encryption implemented in...
</th>
<td>kernelspace
</td>
<td>kernelspace
</td>
<td>kernelspace
</td>
<td>kernelspace
</td>
<td>kernelspace
</td>
<td>userspace (<a href="/title/FUSE" title="FUSE">FUSE</a>)
</td>
<td>userspace (<a href="/title/FUSE" title="FUSE">FUSE</a>)
</td>
<td>kernelspace
</td></tr>
<tr>
<th>Cryptographic metadata stored in...
</th>
<td>?
</td>
<td>with LUKS: LUKS Header
</td>
<td>begin/end of (decrypted) device (<a rel="nofollow" class="external text" href="https://www.veracrypt.fr/en/VeraCrypt%20Volume%20Format%20Specification.html">format spec</a>)
</td>
<td>DSL (dataset &amp; snapshot layer; <a rel="nofollow" class="external text" href="https://www.youtube.com/watch?v=frnLiXclAMo">talk</a>/<a rel="nofollow" class="external text" href="https://blog.heckel.xyz/wp-content/uploads/2017/01/zfs-encryption-nov-2016.pdf">slides</a>)
</td>
<td>header  of  each encrypted file
</td>
<td>control file at the top level of each EncFS container
</td>
<td>?
</td>
<td><code>.fscrypt</code> directory at root of each filesystem
</td></tr>
<tr>
<th>Wrapped encryption key stored in...
</th>
<td>?
</td>
<td>with LUKS: LUKS header
</td>
<td>begin/end of (decrypted) device (<a rel="nofollow" class="external text" href="https://www.veracrypt.fr/en/VeraCrypt%20Volume%20Format%20Specification.html">format spec</a>)
</td>
<td>DSL (dataset &amp; snapshot layer; <a rel="nofollow" class="external text" href="https://www.youtube.com/watch?v=frnLiXclAMo">talk</a>/<a rel="nofollow" class="external text" href="https://blog.heckel.xyz/wp-content/uploads/2017/01/zfs-encryption-nov-2016.pdf">slides</a>)
</td>
<td>key file that can be stored anywhere
</td>
<td>key file that can be stored anywhere
<p><a rel="nofollow" class="external autonumber" href="https://github.com/rfjakob/encfs-next/blob/master/encfs/encfs.pod#environment-variables">[1]</a><a rel="nofollow" class="external autonumber" href="https://github.com/vgough/encfs/issues/48#issuecomment-69301831">[2]</a>
</p>
</td>
<td>?
</td>
<td><code>.fscrypt</code> directory at root of each filesystem
</td></tr>
<tr>
<th style="background: #ddd; color: inherit; vertical-align: middle; text-align: center;">Usability features
</th>
<th>Loop-AES
</th>
<th>dm-crypt +/- LUKS
</th>
<th>VeraCrypt
</th>
<th>ZFS
</th>
<th>eCryptfs
</th>
<th>EncFS
</th>
<th>gocryptfs
</th>
<th>fscrypt
</th></tr>
<tr>
<th>Non-root users can create/destroy containers for encrypted data
</th>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td>limited
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr>
<tr>
<th>Provides a GUI
</th>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
<p><a href="/title/EncFS#Gnome_Encfs_Manager" title="EncFS">optional</a>
</p>
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td></tr>
<tr>
<th>Support for automounting on login
</th>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
<p>with <a href="/title/VeraCrypt#Automounting_using_/etc/crypttab" title="VeraCrypt">systemd and /etc/crypttab</a>
</p>
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes with <a href="/title/ZFS#Unlock/Mount_at_boot_time:_systemd" title="ZFS">systemd</a>
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr>
<tr>
<th>Support for automatic unmounting in case of inactivity
</th>
<td>?
</td>
<td>?
</td>
<td>?
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br><a rel="nofollow" class="external autonumber" href="https://github.com/rfjakob/gocryptfs/blob/master/Documentation/MANPAGE.md#-i-duration--idle-duration">[3]</a>
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td></tr>
<tr>
<th style="background: #ddd; color: inherit; vertical-align: middle; text-align: center;">Security features
</th>
<th>Loop-AES
</th>
<th>dm-crypt +/- LUKS
</th>
<th>VeraCrypt
</th>
<th>ZFS
</th>
<th>eCryptfs
</th>
<th>EncFS
</th>
<th>gocryptfs
</th>
<th>fscrypt
</th></tr>
<tr>
<th>Supported ciphers
</th>
<td>AES
</td>
<td>AES, Anubis, CAST5/6, Twofish, Serpent, Camellia, Blowfish,… (every cipher the kernel Crypto API offers)
</td>
<td>AES, Twofish, Serpent, Camellia, Kuznyechik
</td>
<td>AES
</td>
<td>AES, Blowfish, Twofish...
</td>
<td>AES, Blowfish, Twofish, and any other ciphers available on the system
</td>
<td>AES
</td>
<td>AES, ChaCha12
</td></tr>
<tr>
<th>Integrity
</th>
<td>none
</td>
<td>optional in LUKS2
</td>
<td>none
</td>
<td>CCM, GCM
</td>
<td>none
</td>
<td>none (default mode)<br>HMAC (paranoia mode)
</td>
<td>GCM
</td>
<td>none
</td></tr>
<tr>
<th>Support for salting
</th>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br>(with LUKS)
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr>
<tr>
<th>Support for cascading multiple ciphers
</th>
<td>?
</td>
<td>Not in one device, but blockdevices can be cascaded
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
<p>AES-Twofish, AES-Twofish-Serpent, Serpent-AES, Serpent-Twofish-AES, Twofish-Serpent
</p>
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td>?
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td></tr>
<tr>
<th>Support for key-slot diffusion
</th>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br>(with LUKS)
</td>
<td>?
</td>
<td>?
</td>
<td>?
</td>
<td>?
</td>
<td>?
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td></tr>
<tr>
<th>Protection against key scrubbing
</th>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br>(without LUKS)
</td>
<td>?
</td>
<td>?
</td>
<td>?
</td>
<td>?
</td>
<td>?
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td></tr>
<tr>
<th>Support for multiple (independently revocable) keys for the same encrypted data
</th>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br>(with LUKS)
</td>
<td>?
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td>?
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr>
<tr>
<th style="background: #ddd; color: inherit; vertical-align: middle; text-align: center;">Performance features
</th>
<th>Loop-AES
</th>
<th>dm-crypt +/- LUKS
</th>
<th>VeraCrypt
</th>
<th>ZFS
</th>
<th>eCryptfs
</th>
<th>EncFS
</th>
<th>gocryptfs
</th>
<th>fscrypt
</th></tr>
<tr>
<th>Multithreading support
</th>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br><a rel="nofollow" class="external autonumber" href="https://kernelnewbies.org/Linux_2_6_38#head-49f5f735853f8cc7c4d89e5c266fe07316b49f4c">[4]</a>
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td>?
</td>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr>
<tr>
<th>Hardware-accelerated encryption support
</th>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br><a rel="nofollow" class="external autonumber" href="https://github.com/vgough/encfs/issues/118">[5]</a>
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr>
<tr>
<th style="background: #ddd; color: inherit; vertical-align: middle; text-align: center;">Block device encryption specific
</th>
<th>Loop-AES
</th>
<th>dm-crypt +/- LUKS
</th>
<th>VeraCrypt
</th>
<th>ZFS
</th>
<th colspan="4" rowspan="2" style="background: #ddd; color: inherit; vertical-align: middle; text-align: center;">
</th></tr>
<tr>
<th>Support for (manually) resizing the encrypted block device in-place
</th>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr>
<tr>
<th style="background: #ddd; color: inherit; vertical-align: middle; text-align: center;">Stacked filesystem encryption specific
</th>
<th colspan="3" rowspan="5" style="background: #ddd; color: inherit; vertical-align: middle; text-align: center;">
</th>
<th>ZFS
</th>
<th>eCryptfs
</th>
<th>EncFS
</th>
<th>gocryptfs
</th>
<th>fscrypt
</th></tr>
<tr>
<th>Supported file systems
</th>
<td>ZFS
</td>
<td>ext3, ext4, xfs (with caveats), jfs, nfs...
</td>
<td>ext3, ext4, xfs (with caveats), jfs, nfs, cifs...
<p><a rel="nofollow" class="external autonumber" href="https://github.com/vgough/encfs">[6]</a>
</p>
</td>
<td>any
</td>
<td>ext4, F2FS, UBIFS
</td></tr>
<tr>
<th>Ability to encrypt filenames
</th>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br><a rel="nofollow" class="external text" href="https://zfsonlinux.org/manpages/0.8.3/man8/zfs.8.html#lbAO">zfs(8)</a>
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr>
<tr>
<th>Ability to <i>not</i> encrypt filenames
</th>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br><a rel="nofollow" class="external autonumber" href="https://github.com/rfjakob/gocryptfs/blob/master/Documentation/MANPAGE.md#-plaintextnames">[7]</a>
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td></tr>
<tr>
<th>Optimized handling of sparse files
</th>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td></tr>
<tr>
<th style="background: #ddd; color: inherit; vertical-align: middle; text-align: center;">Compatibility &amp; prevalence
</th>
<th>Loop-AES
</th>
<th>dm-crypt +/- LUKS
</th>
<th>VeraCrypt
</th>
<th>ZFS
</th>
<th>eCryptfs
</th>
<th>EncFS
</th>
<th>gocryptfs
</th>
<th>fscrypt
</th></tr>
<tr>
<th>Supported Linux kernel versions
</th>
<td>2.0 or newer
</td>
<td>CBC-mode since 2.6.4, ESSIV 2.6.10, LRW 2.6.20, XTS 2.6.24
</td>
<td>?
</td>
<td>2.6.32 or newer (as of 0.8.3)
</td>
<td>?
</td>
<td>2.4 or newer
</td>
<td>?
</td>
<td>4.1 or newer
</td></tr>
<tr>
<th>Encrypted data can also be accessed from Windows
</th>
<td>?
</td>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br><a rel="nofollow" class="external text" href="https://openzfsonwindows.org/">OpenZFS on Windows</a> (<a rel="nofollow" class="external text" href="https://github.com/openzfsonwindows/ZFSin">repo</a>)
</td>
<td>?
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No (requires admin rights)
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes (cppcryptfs port)
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td></tr>
<tr>
<th>Encrypted data can also be accessed from Mac OS X
</th>
<td>?
</td>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br><a rel="nofollow" class="external text" href="https://openzfsonosx.org/">OpenZFS on OS X</a> (<a rel="nofollow" class="external text" href="https://github.com/openzfsonosx/zfs">repo</a>)
</td>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br><a rel="nofollow" class="external autonumber" href="https://sites.google.com/a/arg0.net/www/encfs-mac-build">[8]</a><sup title="Last check status: 404">[<a href="https://en.wikipedia.org/wiki/Wikipedia:Link_rot" class="extiw" title="wikipedia:Wikipedia:Link rot">dead link</a> 2024-07-30&nbsp;ⓘ]</sup>
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes (beta quality)
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td></tr>
<tr>
<th>Encrypted data can also be accessed from FreeBSD
</th>
<td>?
</td>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br><a rel="nofollow" class="external text" href="https://zfsonfreebsd.github.io/ZoF/">ZFS on FreeBSD</a> (native; <a rel="nofollow" class="external text" href="https://github.com/zfsonfreebsd/ZoF">repo</a>)
</td>
<td>?
</td>
<td data-sort-value="5" style="background: #afa; color: inherit; vertical-align: middle; text-align: center;">Yes<br><a rel="nofollow" class="external autonumber" href="https://www.freshports.org/sysutils/fusefs-encfs/">[9]</a>
</td>
<td>?
</td>
<td data-sort-value="1" style="background: #faa; color: inherit; vertical-align: middle; text-align: center;">No
</td></tr>

<tr>
<th>Used by
</th>
<td>?
</td>
<td>Debian/Ubuntu installer (system encryption)<br>Fedora installer
</td>
<td>?
</td>
<td>?
</td>
<td>?
</td>
<td>?
</td>
<td>?
</td>
<td>Android, Chrome OS
</td></tr></tbody></table>

</body>
</html>