{% if grains['os_family'] == 'Debian' %}

install-php-tools:
  pkg.installed:
    - pkgs:
      - php-cli          # PHP Command Line Interface
      - php-dev          # Development headers
      - php-mbstring     # String handling
      - php-xml          # XML processing
      - composer         # PHP dependency manager

setup-composer-global-bin:
  file.append:
    - name: /home/{{ grains['username'] }}/.bashrc
    - text: |
        export PATH=$PATH:/home/{{ grains['username'] }}/.composer/vendor/bin
    - unless: grep -q '.composer/vendor/bin' /home/{{ grains['username'] }}/.bashrc

{% else %}

php-tools-not-supported:
  test.fail_without_changes:
    - name: "PHP tools not supported on this OS."

{% endif %}
