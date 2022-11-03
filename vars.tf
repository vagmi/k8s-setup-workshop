variable "do_token" {
  type        = string
  description = "DO Token"
}

variable "do_region" {
  type        = string
  description = "DigitalOcean region"
  default     = "tor1"
}

variable "prefix" {
  type        = string
  description = "project prefix"
  default     = "k8stor"
}

variable "droplet_size" {
  type        = string
  description = "droplet type"
  default     = "s-2vcpu-4gb"
}

variable "worker_count" {
  type        = number
  description = "worker count"
  default     = 2
}
