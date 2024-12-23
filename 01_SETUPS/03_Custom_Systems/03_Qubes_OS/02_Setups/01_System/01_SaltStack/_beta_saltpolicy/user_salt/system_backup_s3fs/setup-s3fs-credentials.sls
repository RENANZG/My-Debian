{% import_json "backup/config.json" as config %}

setup-s3fs-credentials:
  file.managed:
    - name: /root/.passwd-s3fs
    - source: "salt://backup/passwd-s3fs.j2"
    - template: jinja
    - context:
        access_key_id: {{ config.access_key_id }}
        secret_access_key: {{ config.secret_access_key }}
    - user: root
    - group: root
    - mode: 600
