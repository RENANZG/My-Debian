### Getting ZuluCrypt to Work in a Debian 12 Minimal Template

**Issue**: ZuluCrypt GUI requires root rights.

#### Instructions

1. **Install ZuluCrypt**:
   Install it as you would on any minimal template.

2. **Open Terminal in AppVM**:
   ```bash
   [user@dom0 ~]$ qvm-run -u root debian-12-appvm xterm
   ```

3. **Edit Policy File**:
   ```bash
   [root@debian-12-encryption ~]$ nano /usr/share/polkit-1/actions/org.zulucrypt.zulupolkit.policy
   ```

   Change:
   ```xml
   <allow_active>auth_admin</allow_active>
   ```
   to:
   ```xml
   <allow_active>yes</allow_active>
   ```

4. **Note on VeraCrypt**: If you encounter issues with VeraCrypt files requiring image keyfiles, consider removing their keyfile requirements.

This should help ZuluCrypt run without needing root access in your Debian template.