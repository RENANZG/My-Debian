{% if grains['os_family'] == 'Debian' %}

install-c-cpp-tools:
  pkg.installed:
    - pkgs:
      - build-essential  # GCC, G++, Make
      - gdb              # Debugger
      - cmake            # Build system
      - pkg-config       # Package configuration
      - valgrind         # Memory debugging
      - clang            # Alternative compiler
      - libc-dev

{% else %}

c-cpp-tools-not-supported:
  test.fail_without_changes:
    - name: "C/C++ tools not supported on this OS."

{% endif %}
