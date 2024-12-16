{% if grains['os_family'] == 'Debian' %}

install-ruby-tools:
  pkg.installed:
    - pkgs:
      - ruby
      - rubygems

install-global-ruby-gems:
  cmd.run:
    - name: gem install bundler rails
    - unless: gem list bundler rails

setup-gem-bin-path:
  file.append:
    - name: /home/{{ grains['username'] }}/.bashrc
    - text: |
        export PATH=$PATH:/home/{{ grains['username'] }}/.gem/ruby/{{ grains['osrelease'] }}/bin
    - unless: grep -q '.gem/ruby' /home/{{ grains['username'] }}/.bashrc

{% else %}

ruby-tools-not-supported:
  test.fail_without_changes:
    - name: "Ruby tools not supported on this OS."

{% endif %}
