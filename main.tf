provider "google" {
  project = "ruyuk-432100"
  region  = "asia-southeast2"  # Jakarta region
}

resource "google_container_cluster" "primary" {
  name     = "ruyuk-cluster"
  location = "asia-southeast2-a"  # Jakarta zone

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = [
      node_config[0].oauth_scopes,
    ]
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "ruyuk-node-pool"
  location = "asia-southeast2-a"  # Jakarta zone
  cluster  = google_container_cluster.primary.name

  node_count = 3

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

output "kubeconfig" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_location" {
  value = google_container_cluster.primary.location
}
