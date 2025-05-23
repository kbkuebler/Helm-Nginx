{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "hammerspace-monitoring.name" -}}
{{- if .Chart -}}
{{- if .Values -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- if .Values -}}
{{- default "hammerspace-monitoring" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- "hammerspace-monitoring" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hammerspace-monitoring.fullname" -}}
{{- $name := include "hammerspace-monitoring.name" . -}}
{{- if .Release -}}
{{- if .Values -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- else -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- else -}}
{{- $name -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hammerspace-monitoring.chart" -}}
{{- if .Chart -}}
{{- if .Chart.Version -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- "hammerspace-monitoring" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "hammerspace-monitoring.labels" -}}
{{- if .Chart -}}
helm.sh/chart: {{ include "hammerspace-monitoring.chart" . }}
{{- end }}
{{ include "hammerspace-monitoring.selectorLabels" . }}
{{- if .Chart -}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}
{{- if .Release -}}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hammerspace-monitoring.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hammerspace-monitoring.name" . }}
{{- if .Release -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- end }}

{{/*
Create the name of a component
*/}}
{{- define "hammerspace-monitoring.componentName" -}}
{{- $componentName := index . 1 }}
{{- $context := index . 0 }}
{{- printf "%s-%s" (include "hammerspace-monitoring.fullname" $context) $componentName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Reusable PVC template:
Usage:
{{ include "hammerspace-monitoring.pvc" (list . "grafana" .Values.grafana) }}
*/}}
{{- define "hammerspace-monitoring.pvc" -}}
{{- $root := index . 0 -}}
{{- $component := index . 1 -}}
{{- $config := index . 2 -}}
{{- if and $config $config.persistence $config.persistence.enabled -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "hammerspace-monitoring.componentName" (list $root $component) }}
  labels:
    {{- include "hammerspace-monitoring.labels" $root | nindent 4 }}
    app.kubernetes.io/component: {{ $component }}
spec:
  accessModes: {{ toYaml $config.persistence.storage.accessModes | nindent 4 }}
  resources:
    requests:
      storage: {{ $config.persistence.storage.size }}
  storageClassName: {{ $config.persistence.storage.storageClassName | quote }}
{{- end -}}
{{- end -}}
