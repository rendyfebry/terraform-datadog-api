variable "enabled" {
  type        = bool
  default     = true
  description = "To enable this module"
}

variable "product_domain" {
  type        = string
  description = "The name of the product domain"
}

variable "service" {
  type        = string
  description = "The name of the service"
}

variable "cluster" {
  type        = string
  description = "The name of the cluster"
}

variable "environment" {
  type        = string
  default     = "*"
  description = "The name of the environment"
}

variable "tags" {
  type        = list(string)
  default     = []
  description = "Additional tags for monitors"
}

variable "recipients" {
  type        = list(string)
  default     = []
  description = "Notification recipients when both alert and warning are triggered"
}

variable "alert_recipients" {
  type        = list(string)
  default     = []
  description = "Notification recipients when only alert is triggered"
}

variable "warning_recipients" {
  type        = list(string)
  default     = []
  description = "Notification recipients when only warning is triggered"
}

variable "renotify_interval" {
  type        = string
  default     = "0"
  description = "Time interval in minutes which escalation_message will be sent when monitor is triggered"
}

variable "notify_audit" {
  type        = bool
  default     = false
  description = "Whether any configuration changes should be notified"
}

variable "latency_p95_name" {
  type        = string
  default     = ""
  description = "The name for API Latency monitor, else use default"
}

variable "latency_p95_thresholds" {
  type = map(string)

  default = {
    critical = "No default value"
  }

  description = "The warning and critical thresholds for API Latency monitoring"
}

variable "latency_p95_message" {
  type        = string
  default     = ""
  description = "The message when API Latency monitor triggered"
}

variable "latency_p95_escalation_message" {
  type        = string
  default     = ""
  description = "The escalation message when API Latency monitor isn't resolved for given time"
}

variable "latency_p95_include_tags" {
  type        = bool
  default     = true
  description = "The flag to include tags in name for API Latency monitor"
}

variable "exception_name" {
  type        = string
  default     = ""
  description = "The name for API Exception monitor, else use default"
}

variable "exception_thresholds" {
  type = map(string)

  default = {
    critical = "No default value"
  }

  description = "The warning and critical thresholds for API Exception monitoring"
}

variable "exception_message" {
  type        = string
  default     = ""
  description = "The message when API Exception monitor triggered"
}

variable "exception_escalation_message" {
  type        = string
  default     = ""
  description = "The escalation message when API Exception monitor isn't resolved for given time"
}

variable "exception_include_tags" {
  type        = bool
  default     = true
  description = "The flag to include tags in name for API Exception monitor"
}

variable "monitor_exception_time_evaluation" {
  type        = string
  default     = "last_1m"
  description = "time window evaluation that triggers an alert for API Exception"
}

variable "api_latency_p95_custom_query" {
  type        = string
  default     = ""
  description = "The custom query for API Latency P95 monitoring"
}

variable "api_exception_custom_query" {
  type        = string
  default     = ""
  description = "The custom query for API Response Exception monitoring"
}
