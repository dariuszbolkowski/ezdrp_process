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
{{- define "ezdrp.connstring.ezdrp.host" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Host=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "Server=([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^,]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Data Source=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^:]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Server=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}
{{- end -}}


{{/*
regexp ezdrp port :
*/}}
{{- define "ezdrp.connstring.ezdrp.port" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Port=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | default (printf "5432") }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Server=)([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match := $match | toString | regexFind ",[^;]+" }}
    {{- $match | trimAll "," | default (printf "1433") }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Data Source=)[^;]+" }}
    {{- $match := $match | toString | regexFind ":[^\\/]+" }}
    {{- $match | trimAll ":" | default (printf "1521") }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Port=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | default (printf "3306") }}
  {{- end }}
{{- end -}}


{{/*
regexp ezdrp username :
*/}}
{{- define "ezdrp.connstring.ezdrp.username" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Username=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(User Id=)([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Id=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Uid=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end }}
{{- end -}}


{{/*
regexp ezdrp password :
*/}}
{{- define "ezdrp.connstring.ezdrp.password" }}
  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Password=')[^'']+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Password=')[^'']+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Password=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Pwd=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end }}
{{- end -}}

{{/*
regexp ezdrp database :
*/}}
{{- define "ezdrp.connstring.ezdrp.dbname" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Database=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Database=)([^;=]+)[;]" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Data Source=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "/[^;]+" | trimAll "'/'" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrp) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrp | toString | regexFind "(Database=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}
{{- end -}}

{{/*
############################## KUIP connstring ###########################
*/}}

{{/*
regexp kuip host :
*/}}
{{- define "ezdrp.connstring.kuip.host" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Host=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "Server=([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^,]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Data Source=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^:]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Server=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}
{{- end -}}


{{/*
regexp kuip port :
*/}}
{{- define "ezdrp.connstring.kuip.port" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Port=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | default (printf "5432") }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Server=)([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match := $match | toString | regexFind ",[^;]+" }}
    {{- $match | trimAll "," | default (printf "1433") }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Data Source=)[^;]+" }}
    {{- $match := $match | toString | regexFind ":[^\\/]+" }}
    {{- $match | trimAll ":" | default (printf "1521") }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Port=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | default (printf "3306") }}
  {{- end }}
{{- end -}}


{{/*
regexp kuip username :
*/}}
{{- define "ezdrp.connstring.kuip.username" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Username=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(User Id=)([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Id=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Uid=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end }}
{{- end -}}


{{/*
regexp kuip password :
*/}}
{{- define "ezdrp.connstring.kuip.password" }}
  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Password=')[^'']+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Password=')[^'']+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Password=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Pwd=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end }}
{{- end -}}

{{/*
regexp kuip database :
*/}}
{{- define "ezdrp.connstring.kuip.dbname" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.kuip) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Database=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.kuip) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Database=)([^;=]+)[;]" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.kuip) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Data Source=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "/[^;]+" | trimAll "'/'" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.kuip) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.kuip | toString | regexFind "(Database=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}
{{- end -}}


{{/*
############################## ARCHIWUM connstring ###########################
*/}}

{{/*
regexp archiwum host :
*/}}
{{- define "ezdrp.connstring.archiwum.host" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Host=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "Server=([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^,]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Data Source=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^:]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Server=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}
{{- end -}}


{{/*
regexp archiwum port :
*/}}
{{- define "ezdrp.connstring.archiwum.port" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Port=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | default (printf "5432") }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Server=)([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match := $match | toString | regexFind ",[^;]+" }}
    {{- $match | trimAll "," | default (printf "1433") }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Data Source=)[^;]+" }}
    {{- $match := $match | toString | regexFind ":[^\\/]+" }}
    {{- $match | trimAll ":" | default (printf "1521") }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Port=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | default (printf "3306") }}
  {{- end }}
{{- end -}}


{{/*
regexp archiwum username :
*/}}
{{- define "ezdrp.connstring.archiwum.username" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Username=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(User Id=)([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Id=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Uid=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end }}
{{- end -}}


{{/*
regexp archiwum password :
*/}}
{{- define "ezdrp.connstring.archiwum.password" }}
  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Password=')[^'']+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Password=')[^'']+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Password=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Pwd=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end }}
{{- end -}}

{{/*
regexp archiwum database :
*/}}
{{- define "ezdrp.connstring.archiwum.dbname" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.archiwum) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Database=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.archiwum) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Database=)([^;=]+)[;]" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.archiwum) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Data Source=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "/[^;]+" | trimAll "'/'" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.archiwum) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.archiwum | toString | regexFind "(Database=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}
{{- end -}}

{{/*
############################## EZDRPODCZYT connstring ###########################
*/}}

{{/*
regexp ezdrpodczyt host :
*/}}
{{- define "ezdrp.connstring.ezdrpodczyt.host" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Host=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "Server=([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^,]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Data Source=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^:]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Server=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}
{{- end -}}


{{/*
regexp ezdrpodczyt port :
*/}}
{{- define "ezdrp.connstring.ezdrpodczyt.port" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Port=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | default (printf "5432") }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Server=)([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match := $match | toString | regexFind ",[^;]+" }}
    {{- $match | trimAll "," | default (printf "1433") }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Data Source=)[^;]+" }}
    {{- $match := $match | toString | regexFind ":[^\\/]+" }}
    {{- $match | trimAll ":" | default (printf "1521") }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Port=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | default (printf "3306") }}
  {{- end }}
{{- end -}}


{{/*
regexp ezdrpodczyt username :
*/}}
{{- define "ezdrp.connstring.ezdrpodczyt.username" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Username=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(User Id=)([^;=]+)[;]" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Id=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Uid=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" }}
  {{- end }}
{{- end -}}


{{/*
regexp ezdrpodczyt password :
*/}}
{{- define "ezdrp.connstring.ezdrpodczyt.password" }}
  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Password=')[^'']+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Password=')[^'']+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Password=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Pwd=)[^;]+" }}
    {{- $match := $match | toString | regexFind "=[^;]+" }}
    {{- $match | trimAll "=" | trimAll "'='" }}
  {{- end }}
{{- end -}}

{{/*
regexp ezdrpodczyt database :
*/}}
{{- define "ezdrp.connstring.ezdrpodczyt.dbname" -}}

  {{- if (eq "POSTGRESQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) }}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Database=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "SQLSERVER" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Database=)([^;=]+)[;]" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "ORACLE" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Data Source=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "/[^;]+" | trimAll "'/'" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}

  {{- if (eq "MYSQL" .Values.cloudadmin.relationaldb.connectiontype.ezdrpodczyt) -}}
    {{- $match := .Values.cloudadmin.relationaldb.connectionstring.ezdrpodczyt | toString | regexFind "(Database=)[^;]+" -}}
    {{- $match := $match | toString | regexFind "=[^;]+" -}}
    {{- $match | trimAll "=" -}}
  {{- end -}}
{{- end -}}