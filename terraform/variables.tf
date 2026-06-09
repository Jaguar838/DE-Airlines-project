variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "gcp-id-project"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west3"
}

variable "gcs_bucket_name" {
  description = "Name of the raw data lake bucket (must be globally unique)"
  type        = string
  default     = "de-airlines-bucket"
}

variable "bq_dataset_raw" {
  description = "BigQuery dataset for raw loaded data"
  type        = string
  default     = "de_airlines_dataset"
}

variable "bq_dataset_marts" {
  description = "BigQuery dataset for dbt marts"
  type        = string
  default     = "de_airlines_marts"
}
