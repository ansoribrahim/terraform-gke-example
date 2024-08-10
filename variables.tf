variable "project_id" {
  description = "The project ID to deploy the GKE cluster"
  type        = string
  default     = "ruyuk"
}

variable "region" {
  description = "The region to deploy the GKE cluster"
  type        = string
  default     = "asia-southeast2"
}

variable "zone" {
  description = "The zone to deploy the GKE cluster"
  type        = string
  default     = "asia-southeast2-a"
}
