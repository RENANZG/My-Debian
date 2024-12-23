{% if grains['os_family'] == 'Debian' %}

# Install essential system development tools
install-base-dev-tools:
  pkg.installed:
    - pkgs:
      - build-essential  # GCC, G++, Make for compiling
      - git              # Version control system
      - curl             # Data transfer tool
      - wget             # Data transfer tool
      - unzip            # Extract files
      - vim              # Command-line text editor
      - man-db           # Manual pages

# Configure Git globally (Optional)
setup-git-global-config:
  cmd.run:
    - name: |
        git config --global user.name "{{ grains['username'] }}"
        git config --global user.email "{{ grains['username'] }}@example.com"
    - unless: test -f /home/{{ grains['username'] }}/.gitconfig

# Ensure useful directories exist
ensure-directories:
  file.directory:
    - name: /home/{{ grains['username'] }}/workspace
    - user: {{ grains['username'] }}
    - group: {{ grains['username'] }}
    - mode: '0755'
    - makedirs: True

{% else %}

base-dev-tools-not-supported:
  test.fail_without_changes:
    - name: "Base development tools are not supported on this OS family."

{% endif %}
