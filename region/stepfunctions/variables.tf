# Step Functions specifics
variable "name" {
  description = "The name of the Step Function workflow. Will be appended with the environment name."
}

variable "lambda_arns" {
  description = "A list of ALL Lambda ARNs you want this Step Function Workflow - these must be set even if you specify them in the `definition_template_file`, as this argument is used (in part) to generate a role to allow executing against these Lambdas. Consider using `data aws_lambda_function` objects to look these up by name, if necessary."
  type        = list(string)
}

variable "definition_template_file" {
  description = "Relative path to the Amazon States Language (ASL) template file (See https://docs.aws.amazon.com/step-functions/latest/dg/concepts-amazon-states-language.html for more information). You can substitute in variables with `definition_template_vars`. "
  type        = string
  validation {
    condition     = fileexists(var.definition_template_file)
    error_message = "The definition_template_file must be an extant file."
  }
}

variable "definition_template_vars" {
  description = "Variables required in the Step Functions definition template file"
  type        = map(string)
  default     = {}
}

variable "step_function_workflow_type" {
  description = "The Step Function Workflow Type to use for this Step Function Workflow. See https://docs.aws.amazon.com/step-functions/latest/dg/concepts-standard-vs-express.html for the distinctions. Must be 'STANDARD' or 'EXPRESS'."
  type        = string
  validation {
    condition     = contains(["STANDARD", "EXPRESS"], var.step_function_workflow_type)
    error_message = "The workflow type must be STANDARD or EXPRESS. see https://docs.aws.amazon.com/step-functions/latest/dg/concepts-standard-vs-express.html for the distinctions."
  }
}

variable "step_function_logging_include_execution_data" {
  description = "Determines whether execution data is included in your log. When set to false, data is excluded."
  type        = bool
  default     = true
}

variable "step_function_logging_level" {
  description = "Defines which category of execution history events are logged. Valid values: ALL, ERROR, FATAL, OFF."
  type        = string
  default     = "ALL"
  validation {
    condition     = contains(["ALL", "ERROR", "FATAL", "OFF"], var.step_function_logging_level)
    error_message = "The log level must be ALL, ERROR, FATAL, or OFF."
  }
}

variable "step_function_logging_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
  default     = 30
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, 0], var.step_function_logging_retention_in_days)
    error_message = "The logging retention in days should be 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, or 0."
  }
}

# Capsule standard
variable "capsule_env" {
  description = "The environment this Step Function Workflow belongs to (dev, staging, production)."
  type        = string
}

variable "capsule_team" {
  description = "The team that owns this Step Function Workflow."
  type        = string
}

variable "capsule_service" {
  description = "The service that owns this Step Function Workflows."
  type        = string
}

# Vanta

variable "vanta_owner" {
  description = "Vanta specific tag to identify resource owner - string (defaults to same as capsule_team)"
  type        = string
  default     = null
}

variable "vanta_description" {
  description = "Vanta specific tag to specify the purpose of resource - string value"
  type        = string
}

variable "vanta_user_data" {
  description = "Vanta specific tag to specify if the resource will contain user data - true or false"
  type        = bool
}

variable "vanta_user_data_stored" {
  description = "Vanta specific tag to specify the type of data the resource transacts/stores - string value"
  type        = string
}

variable "vanta_contains_ephi" {
  description = "Vanta specific tag to specify if the resource contains PHI - true or false"
  type        = bool
}
