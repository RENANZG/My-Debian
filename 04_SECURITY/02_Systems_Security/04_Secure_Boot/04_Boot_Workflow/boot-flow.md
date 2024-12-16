erDiagram
    POWER-ON {
        string Action
    }
    PRE-VERIFICATION {
        string Action
    }
    PLATFORM-INITIALIZATION {
        string Action
    }
    SHIM {
        string Description
    }
    UEFI-FIRMWARE {
        string Manufacturer
        string Version
    }
    BOOT-LOADER {
        string Name
        string Version
    }
    INITRD {
        string Contents
    }
    TPM-MEASUREMENTS {
        string Measurement
    }
    ENCRYPTED-ROOT-FILE-SYSTEM {
        string FilesystemType
    }
    KERNEL {
        string Version
    }
    SYSTEMD-OR-INIT {
        string InitSystem
    }
    USER-SPACE-AND-SERVICES {
        string Services
    }

    POWER-ON ||--|| PRE-VERIFICATION : triggers
    PRE-VERIFICATION ||--|| PLATFORM-INITIALIZATION : verifies
    PLATFORM-INITIALIZATION ||--|| UEFI-FIRMWARE : initializes
    UEFI-FIRMWARE ||--|| SHIM : loads
    SHIM ||--|| BOOT-LOADER : loads
    BOOT-LOADER ||--|| INITRD : loads
    INITRD ||--|| TPM-MEASUREMENTS : checks
    TPM-MEASUREMENTS ||--|| INITRD : validates
    INITRD ||--|| ENCRYPTED-ROOT-FILE-SYSTEM : asks_for_password
    ENCRYPTED-ROOT-FILE-SYSTEM ||--|| INITRD : decrypts_and_mounts
    INITRD ||--|| KERNEL : loads
    KERNEL ||--|| SYSTEMD-OR-INIT : starts
    SYSTEMD-OR-INIT ||--|| USER-SPACE-AND-SERVICES : initializes
