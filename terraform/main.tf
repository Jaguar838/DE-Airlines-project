provider "google" {
  project = var.project_id
  region  = var.region
}

# --- STORAGE LAYER (DATA LAKE) ---
resource "google_storage_bucket" "data_lake" {
  name          = var.gcs_bucket_name
  location      = var.region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  # IN PROD: set to false to avoid accidental data deletion
  force_destroy = false 

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action { type = "Delete" }
    condition { age = 30 }
  }
}

# --- ANALYTICS LAYER (DWH) ---
resource "google_bigquery_dataset" "dwh" {
  dataset_id = var.bq_dataset_raw
  location   = var.region
  
  # IN PROD: protection against accidental data deletion
  delete_contents_on_destroy = false 
}

# --- TABLES DEFINITION (Explicit Schema) ---

resource "google_bigquery_table" "flights" {
  dataset_id          = google_bigquery_dataset.dataset_id
  table_id            = "flights"
  deletion_protection = false # Can be enabled for critical tables

  time_partitioning {
    type  = "DAY"
    field = "scheduled_departure"
  }

  schema = jsonencode([
    {name: "flight_id",           type: "INT64",     mode: "REQUIRED"},
    {name: "flight_no",           type: "STRING",    mode: "REQUIRED"},
    {name: "scheduled_departure", type: "TIMESTAMP", mode: "REQUIRED"},
    {name: "scheduled_arrival",   type: "TIMESTAMP", mode: "NULLABLE"},
    {name: "departure_airport",   type: "STRING",    mode: "REQUIRED"},
    {name: "arrival_airport",     type: "STRING",    mode: "REQUIRED"},
    {name: "status",              type: "STRING",    mode: "NULLABLE"},
    {name: "aircraft_code",       type: "STRING",    mode: "NULLABLE"}
  ])
}

resource "google_bigquery_table" "bookings" {
  dataset_id          = google_bigquery_dataset.dataset_id
  table_id            = "bookings"
  deletion_protection = false

  time_partitioning {
    type  = "DAY"
    field = "book_date"
  }

  schema = jsonencode([
    {name: "book_ref",    type: "STRING",    mode: "REQUIRED"},
    {name: "book_date",   type: "TIMESTAMP", mode: "REQUIRED"},
    {name: "total_amount", type: "NUMERIC",   mode: "NULLABLE"}
  ])
}

resource "google_bigquery_table" "ticket_flights" {
  dataset_id          = google_bigquery_dataset.dataset_id
  table_id            = "ticket_flights"
  deletion_protection = false

  clustering = ["ticket_no", "flight_id"]

  schema = jsonencode([
    {name = "ticket_no", type = "STRING",  mode = "REQUIRED", description = "Ticket number"},
    {name = "flight_id", type = "INT64",   mode = "REQUIRED", description = "Flight identifier"},
    {name = "fare_conditions", type = "STRING", mode = "REQUIRED", description = "Service class (Economy, Business, Comfort)"},
    {name = "amount",    type = "NUMERIC", mode = "REQUIRED", description = "Flight cost"}
  ])
}

# --- SECURITY & IAM (Kestra Access) ---

resource "google_service_account" "kestra_sa" {
  account_id   = "kestra-sa"
  display_name = "Kestra ETL Runner"
}

# 1. Bucket write access
resource "google_storage_bucket_iam_member" "kestra_gcs" {
  bucket = google_storage_bucket.data_lake.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.kestra_sa.email}"
}

# 2. BigQuery data access
resource "google_bigquery_dataset_iam_member" "kestra_bq_data" {
  dataset_id = google_bigquery_dataset.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.kestra_sa.email}"
}

# 3. CRITICAL: Permission to run jobs at the PROJECT level
resource "google_project_iam_member" "kestra_bq_jobs" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.kestra_sa.email}"
}