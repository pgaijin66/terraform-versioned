variable "name" {
  type        = string
  default     = null
  description = "The additional identifier you'd like for the canary. This will be appended to capsule_service-capsule-env"
}
variable "handler" {
  type        = string
  description = "The name of the handler function. Must end in .handler"
}

variable "runtime_version" {
  type        = string
  description = "The runtime version to use for this canary."
}

variable "private_endpoint" {
  type        = bool
  description = "Whether the endpoint being probed is internal or internet-facing."
  default     = false
}

variable "minutes" {
  type        = number
  default     = 5
  description = "The amount of minutes to wait between each canary runs. Valid values are 1-59"

  validation {
    condition     = contains(range(1, 59), var.minutes)
    error_message = "The number of minutes to wait must be between 1 and 59."
  }
}

variable "secret_value" {
  type        = string
  default     = null
  description = "The value for the secret that will be created for this canary."
}

variable "secret_recovery_window_in_days" {
  type        = number
  default     = 0
  description = "The recovery window in days for the secret that will be created for this canary."
}

variable "alert_on_failure" {
  type        = bool
  description = "Create a CloudWatch alarm alongside this that will alert if success percent drops below 90 over 300 seconds"
  default     = false
}

variable "alert_queue" {
  type        = string
  description = "SNS ARN to send alarms/OK state changes to. Generally an OpsGenie queue. Defaults to the SRE OpsGenie queue."
  default     = "arn:aws:sns:us-east-1:874873923888:OpsGenie"
}


variable "capsule_team" {
  description = "The name of the team that this canary will be associated with"
  type        = string

  # DEVOPS-3342: Automatically manage this instead of hard-coding team names
  validation {
    condition = contains([
      "automation",
      "configurables",
      "consumer",
      "data",
      "doctor",
      "growth",
      "io-team",
      "it",
      "ops-workflows",
      "pai",
      "partnerships",
      "pharmacy-software",
      "post-checkout",
      "pre-checkout",
      "processing-automation",
      "sre",
      "vesto"
    ], var.capsule_team)
    error_message = "The capsule_team var must be a recognized team in terraform-modules-sre/region/cloudwatch/synthetics/variables.tf -- temporary validation until we have programmatic OpsGenie routing (see DEVOPS-3342)."
  }
}

variable "capsule_service" {
  description = "The name of the service that this canary will be associated with"
  type        = string
}

variable "capsule_env" {
  description = "The environment that this canary will be deployed into (dev, staging, production)"
  type        = string
}

variable "canary_steps" {
  description = "A list of the named steps in your Canary function"
  type        = list(string)
  default     = null
}

variable "success_percent_alert_eval_period" {
  description = "The timeframe that success percent alert is evaluated over"
  type        = string
  default     = "10m"
}

variable "success_percent_alert_threshold" {
  description = "The threshold to trigger success percent alert"
  type        = string
  default     = "90"
}

variable "success_percent_alert_runbook_url" {
  description = "The runbook url for success percent alert"
  type        = string
  default     = "https://add-a-runbook.com"
}

variable "success_percent_alert_severity" {
  description = "The severity for success percent alert"
  type        = string
  default     = "info"
}

variable "alarm_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold"
  type        = number
  default     = 3
}

variable "alarm_period_seconds" {
  description = "The period in seconds over which the specified statistic is applied"
  type        = number
  default     = 300
}

variable "alarm_threshold" {
  description = "The value against which the specified statistic is compared"
  type        = number
  default     = 90
}

variable "alarm_num_datapoints_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm"
  type        = number
  default     = 3
}
