``` diff
+ Why Customize UEFI Secure Boot?
```
• Customizing Secure Boot allows administrators to:     
– Respond to certain vulnerabilities without waiting for a BIOS update.      
• For example: fixes to the UEFI security revocation list can be updated manually for the grub2/shim vulnerabilities like BootHole and the 8 additional CVEs disclosed.
• Do this with care, with guidance from your OS provider, to make sure you don’t prevent your platform from booting your current OS version.        
• Customizing Secure Boot allows administrators to:
– Further reduce the attack vectors by:
• Removing the standard UEFI CA certificate from Microsoft from the Secure Boot database.
• Installing signatures or hashes of the specific OS boot loader (and plug-in card option ROMs) in use.
• This prevents any other OS (including all Microsoft OS’ and other versions of Linux) from being booted.
– Disable booting to OS environments which might give the user enhanced access by:
• Disabling external ports (SATA, USB, etc.)
• Preventing the changing of the boot order

``` diff
- Advices
```
• Administrator passwords in most platforms restrict access to BIOS configuration options that control UEFI Secure Boot and other platform security features. Therefore, if the password is not secure, the BIOS is not secure and the platform is not secure.
• Firmware passwords should meet the same industry-wide requirements as OS passwords (complexity, length, re-use, etc.)
– Possibly add 2nd-factor such as a secure dongle, etc.
• Weak or re-used passwords are still a problem that requires each organization to establish a policy for creating and tracking passwords.      
