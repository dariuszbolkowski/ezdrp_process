{{/*
Expand the name of the chart.
*/}}
{{- define "EZDRP-HA.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "EZDRP-HA.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "EZDRP-HA.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "EZDRP-HA.labels" -}}
helm.sh/chart: {{ include "EZDRP-HA.chart" . }}
{{ include "EZDRP-HA.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "EZDRP-HA.selectorLabels" -}}
app.kubernetes.io/name: {{ include "EZDRP-HA.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "EZDRP-HA.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "EZDRP-HA.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "imagePullSecret" }}
{{- with .Values.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry (printf "%s" .username | b64dec | b64dec | trim ) (printf "%s" .password | b64dec | b64dec | trim ) (printf "%s" .email | b64dec | b64dec | trim ) (printf "%s:%s" (printf "%s" .username | b64dec | b64dec | trim) (printf "%s" .password | b64dec | b64dec | trim) | b64enc) | b64enc }}
{{- end }}
{{- end }}


{{/*
############################## EZDRP connstring ###########################
*/}}


{{/*
regexp ezdrp host :
*/}}

{{- define "ezdrp.connstring.cloudadmin.ezdrp" -}}
Host={{ include "ezdrp.connstring.ezdrp.host" . }};Port={{ include "ezdrp.connstring.ezdrp.port" . }};Database={{ include "ezdrp.connstring.ezdrp.dbname" . }};Username={{ include "ezdrp.connstring.ezdrp.username" . }};Password={{ include "ezdrp.connstring.ezdrp.password" . }}
{{- end -}}


{{- define "ezdrp.connstring.ezdrp.host" -}}
{{ .Values.ezdBackend.postgresqlConfig.fullnameOverride }}-rw
{{- end -}}


{{/*
regexp ezdrp port :
*/}}
{{- define "ezdrp.connstring.ezdrp.port" -}}
{{- print "5432" }}
{{- end -}}


{{/*
regexp ezdrp username :
*/}}
{{- define "ezdrp.connstring.ezdrp.username" -}}
{{- print "postgres" }}
{{- end -}}


{{/*
regexp ezdrp password :
*/}}
{{- define "ezdrp.connstring.ezdrp.password" }}
{{- .Values.global.postgresqlConfig.auth.admPassword }}
{{- end -}}

{{/*
regexp ezdrp database :
*/}}
{{- define "ezdrp.connstring.ezdrp.dbname" -}}
{{- print "ezdrp" }}
{{- end -}}

{{/*
############################## KUIP connstring ###########################
*/}}

{{/*
regexp kuip host :
*/}}

{{- define "ezdrp.connstring.cloudadmin.kuip" -}}
Host={{ include "ezdrp.connstring.kuip.host" . }};Port={{ include "ezdrp.connstring.kuip.port" . }};Database={{ include "ezdrp.connstring.kuip.dbname" . }};Username={{ include "ezdrp.connstring.kuip.username" . }};Password={{ include "ezdrp.connstring.kuip.password" . }}

{{- end -}}

{{- define "ezdrp.connstring.kuip.host" -}}
{{- .Values.ezdBackend.postgresqlConfig.fullnameOverride }}-rw
{{- end -}}


{{/*
regexp kuip port :
*/}}
{{- define "ezdrp.connstring.kuip.port" -}}
{{- print "5432" }}
{{- end -}}


{{/*
regexp kuip username :
*/}}
{{- define "ezdrp.connstring.kuip.username" -}}
{{- print "postgres" }}
{{- end -}}


{{/*
regexp kuip password :
*/}}
{{- define "ezdrp.connstring.kuip.password" }}
{{- .Values.global.postgresqlConfig.auth.admPassword }}
{{- end -}}

{{/*
regexp kuip database :
*/}}
{{- define "ezdrp.connstring.kuip.dbname" -}}
{{- print "ezdrp" }}
{{- end -}}


{{/*
############################## ARCHIWUM connstring ###########################
*/}}

{{/*
regexp archiwum host :
*/}}
{{- define "ezdrp.connstring.cloudadmin.archiwum" -}}
Host={{ include "ezdrp.connstring.archiwum.host" . }};Port={{ include "ezdrp.connstring.archiwum.port" . }};Database={{ include "ezdrp.connstring.archiwum.dbname" . }};Username={{ include "ezdrp.connstring.archiwum.username" . }};Password={{ include "ezdrp.connstring.archiwum.password" . }}
{{- end -}}

{{- define "ezdrp.connstring.archiwum.host" -}}
{{- .Values.ezdBackend.postgresqlConfig.fullnameOverride }}-rw
{{- end -}}


{{/*
regexp archiwum port :
*/}}
{{- define "ezdrp.connstring.archiwum.port" -}}
{{- print "5432" }}
{{- end -}}


{{/*
regexp archiwum username :
*/}}
{{- define "ezdrp.connstring.archiwum.username" -}}
{{- print "postgres" }}
{{- end -}}


{{/*
regexp archiwum password :
*/}}
{{- define "ezdrp.connstring.archiwum.password" }}
{{- .Values.global.postgresqlConfig.auth.admPassword }}
{{- end -}}

{{/*
regexp archiwum database :
*/}}
{{- define "ezdrp.connstring.archiwum.dbname" -}}
{{- print "archiwum" }}
{{- end -}}

{{/*
############################## EZDRPODCZYT connstring ###########################
*/}}

{{/*
regexp ezdrpodczyt host :
*/}}
{{- define "ezdrp.connstring.cloudadmin.ezdrpodczyt" -}}
Host={{ include "ezdrp.connstring.ezdrpodczyt.host" . }};Port={{ include "ezdrp.connstring.ezdrpodczyt.port" . }};Database={{ include "ezdrp.connstring.ezdrpodczyt.dbname" . }};Username={{ include "ezdrp.connstring.ezdrpodczyt.username" . }};Password={{ include "ezdrp.connstring.ezdrpodczyt.password" . }}
{{- end -}}

{{- define "ezdrp.connstring.ezdrpodczyt.host" -}}
{{- .Values.ezdBackend.postgresqlConfig.fullnameOverride }}-rw
{{- end -}}


{{/*
regexp ezdrpodczyt port :
*/}}
{{- define "ezdrp.connstring.ezdrpodczyt.port" -}}
{{- print "5432" }}
{{- end -}}


{{/*
regexp ezdrpodczyt username :
*/}}
{{- define "ezdrp.connstring.ezdrpodczyt.username" -}}
{{- print "postgres" }}
{{- end -}}


{{/*
regexp ezdrpodczyt password :
*/}}
{{- define "ezdrp.connstring.ezdrpodczyt.password" }}
{{- .Values.global.postgresqlConfig.auth.admPassword }}
{{- end -}}

{{/*
regexp ezdrpodczyt database :
*/}}
{{- define "ezdrp.connstring.ezdrpodczyt.dbname" -}}
{{- print "ezdrp_odczyt" }}
{{- end -}}
