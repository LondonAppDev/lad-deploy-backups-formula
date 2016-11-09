
{% if 'file_backups' in pillar['backup_client'] %}
{% for file, args in pillar['backup_client']['file_backups'].items() %}

/home/{{ pillar['backup_client']['user'] }}/scripts/{{ file }}_file_backup.sh:
    file.managed:
        - template: jinja
        - source: salt://backups/backup_client/files/file_backup.sh.jinja
        - makedirs: True
        - user: {{ pillar['backup_client']['user'] }}
        - group: {{ pillar['backup_client']['user'] }}
        - context:
            backup_server_user: "{{ pillar['backup_client']['user'] }}"
            backup_server_host: "{{ pillar['backup_client']['backup_server_host'] }}"
            backup_server_remote_path: "{{ pillar['backup_client']['backup_server_remote_path'] }}"
            path_to_backup: "{{ args['path'] }}"
            file_name: "{{ file }}"

sh /home/{{ pillar['backup_client']['user'] }}/scripts/{{ file }}_file_backup.sh:
    cron.present:
        - user: {{ pillar['backup_client']['user'] }}
        {% for k, v in pillar['backup_client']['file_backups'][file]['cron'].items() %}
        - {{ k }}: "{{ v }}"
        {% endfor %}

{% endfor %}
{% endif %}
