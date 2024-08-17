# Google provider configuration
provider "google" {
  project = "ruyuk-432100"
  region  = "asia-southeast2"
}

# Create GKE Cluster
resource "google_container_cluster" "primary" {
  name     = "ruyuk-cluster"
  location = "asia-southeast2-a"
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  # Enable network policy for admission webhooks
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  lifecycle {
    ignore_changes = [
      node_config[0].oauth_scopes,
    ]
  }

  # Addons for monitoring and logging
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    http_load_balancing {
      disabled = false
    }

    network_policy_config {
      disabled = false
    }
  }
}

# Create Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name     = "ruyuk-node-pool"
  location = "asia-southeast2-a"
  cluster  = google_container_cluster.primary.id

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

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

data "google_client_config" "default" {}

# Kubernetes Pod Resource
resource "kubernetes_pod" "notification" {
  metadata {
    name      = "notification-pod"
    namespace = "default"
  }

  spec {
    container {
      name  = "notification-container"
      image = "nginx:latest"
      port {
        container_port = 80
      }
    }
  }
}

# Outputs
output "kubeconfig" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_location" {
  value = google_container_cluster.primary.location
}
