job "api" {
  datacenters = ["dc1"]
  type = "service"

  group "api" {
    count = 1

    network {
      mode = "host"
      port "http" {
        static = 9090
      }
    }
    
    service {
      name = "api-service"
      tags = ["global", "api"]
      port = "http"

      check {
        name     = "liveness"
        type     = "http"
        interval = "10s"
        timeout  = "2s"
        path = "/health"
      }
    }

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"

      mode = "fail"
    }

    ephemeral_disk {
      size = 30
    }

    task "api" {
      driver = "docker"

      env {
        TIMING_50_PERCENTILE = "100ms"
        TIMING_VARIANCE = 25
        LOAD_MEMORY_PER_REQUEST = 104857600
      }

      config {
        image = "nicholasjackson/fake-service:v0.22.0"

        ports = ["http"]
      }

      logs {
        max_files     = 10
        max_file_size = 1
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
      }
    }
  }
}