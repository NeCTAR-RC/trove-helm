{{- define "trove-conf" }}
[DEFAULT]
trove_api_workers=2
trove_conductor_workers=2

guest_config=/etc/trove/guestagent/trove-guestagent.conf

control_exchange = trove
taskmanager_manager=trove.taskmanager.manager.Manager
cinder_service_type=volumev3
network_driver = trove.network.neutron.NeutronDriver
network_label_regex = .*

max_accepted_volume_size = 1024
max_volumes_per_tenant = 0
max_backups_per_tenant = 50
max_ram_per_tenant=0
max_instances_per_tenant=10

# Trove DNS
trove_dns_support = True
dns_account_id = {{ .Values.conf.dns.account_id }}
dns_auth_url = {{ .Values.conf.keystone.auth_url }}
dns_username = {{ .Values.conf.keystone.username }}
dns_ttl = 3600
dns_domain_name = {{ .Values.conf.dns.domain_name }}
dns_domain_id = {{ .Values.conf.dns.domain_id }}
dns_driver = trove.dns.designate.driver.DesignateDriverV2
dns_instance_entry_factory = trove.dns.designate.driver.DesignateInstanceEntryFactory
dns_service_type = dns
dns_user_domain_id=default
dns_project_domain_id=default
dns_time_out=600

# Nectar settings
ensure_az=True
{{- if .Values.conf.az_role_mapping }}
az_role_mapping={{ join "," .Values.conf.az_role_mapping }}
{{- end }}

[database]
connection_recycle_time=600

[mysql]
root_on_create = False
tcp_ports = 3306
volume_support = True
device_path = /dev/vdb
ignore_users = os_admin, root
ignore_dbs = mysql, information_schema, performance_schema

[oslo_middleware]
enable_proxy_headers_parsing = true

[oslo_policy]
policy_file=/etc/trove/policy.yaml

[keystone_authtoken]
auth_url={{ .Values.conf.keystone.auth_url }}
www_authenticate_uri={{ .Values.conf.keystone.auth_url }}
username={{ .Values.conf.keystone.username }}
project_name={{ .Values.conf.keystone.project_name }}
user_domain_name=Default
project_domain_name=Default
auth_type=password
{{- if .Values.conf.keystone.memcached_servers }}
memcached_servers={{ join "," .Values.conf.keystone.memcached_servers }}
{{- end }}
service_type=database
service_token_roles_required=True

[oslo_messaging_rabbit]
ssl=True
rabbit_ha_queues=True
amqp_durable_queues={{ .Values.conf.oslo_messaging_rabbit.amqp_durable_queues }}

[service_credentials]
auth_url={{ .Values.conf.keystone.auth_url }}
region_name={{ .Values.conf.keystone.region_name }}
username={{ .Values.conf.keystone.username }}
project_name={{ .Values.conf.keystone.project_name }}
project_domain_name=Default
user_domain_name=Default
auth_type=password

[audit_middleware_notifications]
driver=log

{{- end }}
