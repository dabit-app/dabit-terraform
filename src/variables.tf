variable "host" {
  type = string
  default = "localhost"
}

variable "namespace" {
  type = string
  default = "default"
}

variable "habit_api_replicas" {
  type = number
  default = 1
}

variable "identity_api_replicas" {
  type = number
  default = 1
}
