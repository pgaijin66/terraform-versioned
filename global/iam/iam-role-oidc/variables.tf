variable "name" {
  default     = null
  type        = string
  description = "Name for the role"
}

variable "aws_account_id" {
  default     = ""
  type        = string
  description = "Account ID where the role should be created. If not set will default to the account that iam caller creating the role belongs to"
}

variable "role_description" {
  default     = ""
  type        = string
  description = "Description of the roles purpose"
}

variable "role_path" {
  default     = "/"
  type        = string
  description = "IAM path for the role"
}

variable "cluster_names" {
  type = list(string)
  validation {
    condition = alltrue([
      for c in var.cluster_names :
      can(
        regex("devtest|prd-internal|prd-external|test|dev|production|sre-test|staging", c)
      )
    ])
    error_message = "The eks_cluster_name variable must contain a valid cluster name."
  }
  description = "Name of the EKS cluster containing the service account"
}

variable "capsule_env" {
  type        = string
  description = "Environment that the role will be used in"
}

variable "capsule_team" {
  type        = string
  description = "Team that maintains the service using the role"
}

variable "capsule_service" {
  type        = string
  description = "Service that will use the role"
}

variable "oidc_fully_qualified_subjects" {
  default     = []
  type        = list(any)
  description = "list of fully qualified subjects that can assume the role"
}

variable "oidc_subjects_with_wildcards" {
  default     = []
  type        = list(any)
  description = "List of subjects with wildcards that can assume the role"
}

variable "abac_actions" {
  default = []
  type = list(object({
    actions = list(string)
  }))
  description = "List of actions that this service should be able to perform on resources it has access to. Should consist of an action block for each resources type (eg rds, sns, etc)"
}

variable "rbac_actions_dynamodb" {
  type        = bool
  default     = false
  description = "Does this service use DynamoDB? If so, a special RBAC policy will be crafted"
}

variable "rbac_actions_kafkaconnect" {
  type        = bool
  default     = false
  description = "Does this service use KafkaConnect? If so, a special RBAC policy will be crafted"
}

variable "rbac_actions_lambda" {
  type        = bool
  default     = false
  description = "Does this service use Lambda? If so, a special RBAC policy will be crafted"
}

variable "rbac_actions_s3" {
  type        = bool
  default     = false
  description = "Does this service use s3? If so, a special RBAC policy will be crafted"
}

variable "rbac_actions_sqs" {
  type        = bool
  default     = false
  description = "Does this service use SQS? If so, a special RBAC policy will be crafted"
}

variable "additional_actions" {
  default = []
  type = list(object({
    actions   = list(string)
    resources = list(string)
  }))
  description = "Additional actions that the service should be able to perform on resources not owned by the service/team."
}

variable "additional_conditional_actions" {
  default = []
  type = list(object({
    actions   = list(string)
    resources = list(string)
    conditions = list(object({
      test     = string
      variable = string
      values   = list(string)
  })) }))
  description = "Additional actions including Conditions (if not adding Conditions, use additional_actions instead)"
}

variable "policy_description" {
  default     = ""
  type        = string
  description = "Descritpion of the policy"
}

variable "assume_role_for_aws_services" {
  default     = []
  type        = list(string)
  description = "List of AWS services that will be added to the trust policy so they can assume this OIDC role"
}
