<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Terminal, Shell, and GNU/Linux Glossary</title>
</head>
<body>

  <table width="90%" align="center" border="1" cellspacing="0" cellpadding="20">
    <tr>
      <td>
        <h1 style="text-align: center;">Terminal, Shell, and GNU/Linux Glossary</h1>
      </td>
    </tr>
  
    <!-- Terminal -->
    <tr>
      <td>
        <h2>Terminal</h2>
        <ul>
          <li><strong>Terminal:</strong> A program that provides a text-based interface for users to interact with the operating system.</li>
          <li><strong>Virtual Terminal (TTY):</strong> A virtual terminal interface accessed via function keys (e.g., <code>CTRL + ALT + F2</code> to <code>F6</code>), providing direct access to the command-line interface.</li>
          <li><strong>Terminal Emulator:</strong> Software application replicating a physical terminal within a graphical environment, commonly used in desktop environments to provide a terminal-like interface.</li>
          <li><strong>Console:</strong> Refers to both the physical hardware where text-based interaction occurs and the combination of hardware and software providing such an interface.</li>
        </ul>
      </td>
    </tr>
  
    <!-- Shell -->
    <tr>
      <td>
        <h2>Shell</h2>
        <ul>
          <li><strong>Shell:</strong> Command-line interpreter providing a user interface for accessing operating system services and executing commands.</li>
          <li><strong>Bash (Bourne Again Shell):</strong> A widely used shell in Unix-like systems, including GNU/Linux distributions, known for its scripting capabilities and interactive command-line features.</li>
          <li><strong>Command-Line Interface (CLI):</strong> The textual interface through which users interact with the computer system by entering commands.</li>
          <li><strong>Shell Scripting:</strong> Writing scripts (sequences of commands) to automate tasks, manage system configurations, and execute complex operations.</li>
          <li><strong>Prompt:</strong> The symbol or text displayed by the shell to indicate readiness to accept commands, typically showing information like the current user, hostname, and directory.</li>
        </ul>
      </td>
    </tr>
  
    <!-- GNU/Linux -->
    <tr>
      <td>
        <h2>GNU/Linux</h2>
        <ul>
          <li><strong>GNU/Linux:</strong> A Unix-like operating system combining the GNU userland and the Linux kernel.</li>
          <li><strong>Linux Distribution:</strong> A version of GNU/Linux packaged with additional software, tools, and utilities, often including a desktop environment or window manager, tailored for specific use cases.</li>
          <li><strong>Kernel:</strong> The core component of the operating system responsible for managing hardware resources (CPU, memory, peripherals) and providing essential services to higher-level software.</li>
          <li><strong>GNU Project:</strong> An initiative by the Free Software Foundation (FSF) to develop a complete, free, and open-source Unix-like operating system, comprising userland utilities and tools used in conjunction with the Linux kernel in GNU/Linux distributions.</li>
        </ul>
      </td>
    </tr>
  
    <!-- System Setup and Containers -->
    <tr>
      <td>
        <h2>System Setup and Containers</h2>
        <ul>
          <li><strong>chroot:</strong> Changes the apparent root directory for the current running process and its children, useful for creating isolated environments or repairing an existing system.</li>
          <li><strong>debootstrap:</strong> A tool to create a minimal Debian-based system within another system, commonly used in system recovery, installation, or creating lightweight environments.</li>
          <li><strong>bootstrap:</strong> Refers to the process of initializing or preparing a system or environment, including setting up essential components and software.</li>
          <li><strong>LXC (Linux Containers):</strong> Provides lightweight OS-level virtualization for running multiple isolated Linux systems (containers) on a single host, sharing the same kernel.</li>
          <li><strong>Docker:</strong> A platform for developing, shipping, and running applications inside containers, providing standardized units of software for deployment.</li>
          <li><strong>Virtualenv:</strong> Creates isolated Python environments, allowing different projects to use different sets of libraries and dependencies without conflicts.</li>
          <li><strong>Vagrant:</strong> Automates the creation and management of virtualized development environments using popular virtualization tools like VirtualBox, allowing consistent and reproducible development environments.</li>
          <li><strong>KVM (Kernel-based Virtual Machine):</strong> A virtualization module in the Linux kernel that enables running multiple virtual machines (VMs) with hardware-level virtualization support, suitable for running different operating systems concurrently.</li>
          <li><strong>systemd-nspawn:</strong> A lightweight containerization tool in systemd for running containers (system containers) providing an isolated environment similar to chroot but with more features.</li>
          <li><strong>Ansible/Puppet/Chef:</strong> Configuration management tools that automate the provisioning, configuration, and deployment of software and infrastructure, ensuring consistency and repeatability in system administration tasks.</li>
        </ul>
      </td>
    </tr>
  
    <!-- Miscellaneous -->
    <tr>
      <td>
        <h2>Miscellaneous</h2>
        <ul>
          <li><strong>Terminal Multiplexer:</strong> A tool like tmux or screen that allows multiple terminal sessions within a single terminal window, enabling multitasking and session management.</li>
          <li><strong>Remote Shell (SSH):</strong> A protocol for secure remote access to a computer or server, providing encrypted communication and remote shell capabilities.</li>
          <li><strong>Interactive vs. Non-Interactive Shells:</strong> Interactive shells allow direct user interaction via a terminal, while non-interactive shells execute commands from scripts or automated processes without user input.</li>
        </ul>
      </td>
    </tr>
   </table>

</body>
</html>
