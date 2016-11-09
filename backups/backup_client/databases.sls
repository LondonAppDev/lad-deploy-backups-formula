{% if 'db_backups' in pillar['backup_client'] %}
# Ensure MySQL user and permissions exists
backups_backup_client_db_user_exists:
    mysql_user.present:
        - connection_user: "{{ pillar['backup_client']['db_backups']['db_connection_user'] }}"
        - connection_pass: "{{ pillar['backup_client']['db_backups']['db_connection_user_pass'] }}"
        - connection_charset: utf8
        - name: "{{ pillar['backup_client']['db_backups']['backup_user'] }}"
        - password: "{{ pillar['backup_client']['db_backups']['backup_user_pass'] }}"
        - host: "{{ pillar['backup_client']['db_backups']['backup_user_host'] }}"

backups_backup_client_db_user_permissions:
    mysql_grants.present:
        - connection_user: "{{ pillar['backup_client']['db_backups']['db_connection_user'] }}"
        - connection_pass: "{{ pillar['backup_client']['db_backups']['db_connection_user_pass'] }}"
        - connection_charset: utf8
        - grant: SELECT, LOCK TABLES
        - database: '*.*'
        - user: "{{ pillar['backup_client']['db_backups']['backup_user'] }}"

{% for db, args in pillar['backup_client']['db_backups']['databases'].items() %}
/home/{{ pillar['backup_client']['user'] }}/scripts/{{ db }}_mysql_backup.sh:
    file.managed:
        - template: jinja
        - source: salt://backups/backup_client/files/mysql_backup.sh.jinja
        - makedirs: True
        - user: {{ pillar['backup_client']['user'] }}
        - group: {{ pillar['backup_client']['user'] }}
        - context:
            db_backup_user: "{{ pillar['backup_client']['db_backups']['backup_user'] }}"
            db_backup_user_pass: "{{ pillar['backup_client']['db_backups']['backup_user_pass'] }}"
            db_name: {{ db }}
            backup_server_user: "{{ pillar['backup_client']['user'] }}"
            backup_server_host: "{{ pillar['backup_client']['backup_server_host'] }}"
            backup_server_remote_path: "{{ pillar['backup_client']['backup_server_remote_path'] }}"

sh /home/{{ pillar['backup_client']['user'] }}/scripts/{{ db }}_mysql_backup.sh:
    cron.present:
        - user: {{ pillar['backup_client']['user'] }}
        {% for k, v in pillar['backup_client']['db_backups']['databases'][db].items() %}
        - {{ k }}: "{{ v }}"
        {% endfor %}
{% endfor %}

{% endif %}
