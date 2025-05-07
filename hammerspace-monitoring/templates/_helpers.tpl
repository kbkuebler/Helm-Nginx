---
# templates/_helpers.tpl
{{/* Define a fullname helper */}}
{{- define "hammerspace-monitoring.fullname" -}}
{{ include "hammerspace-monitoring.name" . }}
{{- end -}}

{{- define "hammerspace-monitoring.name" -}}
{{ .Chart.Name }}
{{- end -}}