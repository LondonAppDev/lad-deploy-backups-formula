
{{ pillar['backup_server']['user'] }}:
    user.present:
        - fullname: Backup Server User
        - home: /home/{{ pillar['backup_server']['user'] }}
        - shell: /bin/bash
        - password: {{ pillar['backup_server']['user_pass']}}

    ssh_auth.present:
        - user: {{ pillar['backup_server']['user'] }}
        - enc: ssh-rsa
        - comment: Backup Server SSH Key
        - names:
            - '{{ pillar["backup_server"]["user_id_rsa_pub"] }}'
