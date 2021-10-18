# kubernetes connection

# option 1 - use ~/.kube

variable "k8s_config_path" {
  type = string
  default = "~/.kube/config"
}

variable "k8s_config_context" {
  type = string
  default = null
}

# option 2 - use certificates

variable "k8s_host" {
  type = string
  default = null
  sensitive = true
}

variable "k8s_client_certificate" {
  type = string
  default = null
  sensitive = true
}

variable "k8s_client_key" {
  type = string
  default = null
  sensitive = true
}

variable "k8s_cluster_ca_certificate" {
  type = string
  default = null
  sensitive = true
}

# dabit deployment options

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
