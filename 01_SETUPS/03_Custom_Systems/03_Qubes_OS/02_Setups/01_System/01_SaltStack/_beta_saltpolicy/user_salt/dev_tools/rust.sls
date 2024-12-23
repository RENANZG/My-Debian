{% if grains['os_family'] == 'Debian' %}

install-rustup:
  cmd.run:
    - name: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    - unless: test -d /home/{{ grains['username'] }}/.cargo

setup-rust-environment:
  file.append:
    - name: /home/{{ grains['username'] }}/.bashrc
    - text: |
        export PATH=$PATH:/home/{{ grains['username'] }}/.cargo/bin
    - unless: grep -q '.cargo/bin' /home/{{ grains['username'] }}/.bashrc

install-rust-packages:
  cmd.run:
    - name: |
        source /home/{{ grains['username'] }}/.cargo/env && \
        cargo install cargo-edit cargo-watch
    - unless: test -x /home/{{ grains['username'] }}/.cargo/bin/cargo-watch

{% else %}

rust-tools-not-supported:
  test.fail_without_changes:
    - name: "Rust tools not supported on this OS."

{% endif %}
