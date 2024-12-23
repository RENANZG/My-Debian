{% if grains['os_family'] == 'Debian' %}

install-python-tools:
  pkg.installed:
    - pkgs:
      - python3          # Python interpreter
      - python3-pip      # Python package manager
      - python3-venv     # Virtual environment
      - python-is-python3 # Alias `python` to `python3`

install-global-python-tools:
  pip.installed:
    - pkgs:
      - pipx            # Python isolated tools
      - flake8          # Python linter
      - black           # Python code formatter
      - pytest          # Testing framework

setup-pipx-path:
  file.append:
    - name: /home/{{ grains['username'] }}/.bashrc
    - text: |
        export PATH=$PATH:/home/{{ grains['username'] }}/.local/bin
    - unless: grep -q 'pipx' /home/{{ grains['username'] }}/.bashrc

{% else %}

python-tools-not-supported:
  test.fail_without_changes:
    - name: "Python tools not supported on this OS."

{% endif %}
