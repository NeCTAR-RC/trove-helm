{{/*
Vault annotations
*/}}
{{- define "trove.vaultAnnotations" -}}
vault.hashicorp.com/role: "{{ .Values.vault.role }}"
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/agent-pre-populate-only: "true"
vault.hashicorp.com/agent-inject-status: "update"
vault.hashicorp.com/secret-volume-path-secrets.conf: /etc/trove/trove.conf.d
vault.hashicorp.com/agent-inject-secret-secrets.conf: "{{ .Values.vault.settings_secret }}"
vault.hashicorp.com/agent-inject-template-secrets.conf: |
  {{ print "{{- with secret \"" .Values.vault.settings_secret "\" -}}" }}
  {{ print "[DEFAULT]" }}
  {{ print "transport_url={{ .Data.data.transport_url }}" }}
  {{ print "dns_passkey={{ .Data.data.keystone_password }}" }}
  {{ print "[oslo_messaging_notification]" }}
  {{ print "transport_url={{ .Data.data.transport_url }}" }}
  {{ print "[database]" }}
  {{ print "connection={{ .Data.data.database_connection }}" }}
  {{ print "[keystone_authtoken]" }}
  {{ print "password={{ .Data.data.keystone_password }}" }}
  {{ print "[service_credentials]" }}
  {{ print "password={{ .Data.data.keystone_password }}" }}
  {{ print "{{- end -}}" }}
vault.hashicorp.com/secret-volume-path-trove-guestagent.conf: /etc/trove/guestagent
vault.hashicorp.com/agent-inject-secret-trove-guestagent.conf: "{{ .Values.vault.guestagent_conf }}"
vault.hashicorp.com/agent-inject-template-trove-guestagent.conf: |
  {{ print "{{- with secret \"" .Values.vault.guestagent_conf "\" -}}" }}
  {{ print "{{ .Data.data.content }}" }}
  {{ print "{{- end -}}" }}
{{- end }}
