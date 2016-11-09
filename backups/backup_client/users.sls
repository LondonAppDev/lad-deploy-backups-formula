# Ensure user exists
{{ pillar['backup_client']['user'] }}:
    user.present:
        - fullname: Backup Client User
        - home: /home/{{ pillar['backup_client']['user'] }}
        - shell: /bin/bash
        - password: "{{ pillar['backup_client']['user_pass'] }}"

/home/{{ pillar['backup_client']['user'] }}/.ssh/id_rsa:
    file.managed:
        - template: jinja
        - source: salt://backups/backup_client/files/id_rsa.jinja
        - user: {{ pillar['backup_client']['user'] }}
        - group: {{ pillar['backup_client']['user'] }}
        - makedirs: True
        - mode: 600

/home/{{ pillar['backup_client']['user'] }}/.ssh/id_rsa.pub:
    file.managed:
        - template: jinja
        - source: salt://backups/backup_client/files/id_rsa.pub.jinja
        - user: {{ pillar['backup_client']['user'] }}
        - group: {{ pillar['backup_client']['user'] }}
        - makedirs: True
        - mode: 700

/home/{{ pillar['backup_client']['user'] }}/.ssh/config:
    file.managed:
        - template: jinja
        - source: salt://backups/backup_client/files/ssh_config.jinja
        - user: {{ pillar['backup_client']['user'] }}
        - group: {{ pillar['backup_client']['user'] }}
        - makedirs: True
        - mode: 700
