job "api" {
  datacenters = ["dc1"]
  type = "service"
  group "api" {
    service {
      name = "api-service"
      tags = ["global", "api"]
      port = "http"
      check {
        name     = "liveness"
        type     = "http"
        interval = "10s"
        timeout  = "1s"
        path = "/health"
        initial_status = "warning"
        success_before_passing = 1
        failures_before_critical = 3
      }
      check {
        name     = "readiness"
        type     = "http"
        interval = "10s"
        timeout  = "1s"
        path = "/ready"
        initial_status = "warning"
        success_before_passing = 1
        failures_before_critical = 3 # After 120s will become critical
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
    count = 1
    network {
      mode = "host"
      port "http" {
        static = 9090
      }
    }
    task "api" {
      driver = "docker"
      env {
        TIMING_50_PERCENTILE = "1s"
        TIMING_VARIANCE = 25
        LOAD_MEMORY_PER_REQUEST = 10485760 #  10485760 20971520 10MB per request x 10 users in load test = 100MB +/- 100MB 
        LOAD_MEMORY_VARIANCE = 100 # 100% variance
        READY_CHECK_RESPONSE_DELAY = "60s"
        READY_CHECK_RESPONSE_FAILURE_CODE = 500
      }
      config {
        image = "nicholasjackson/fake-service:v0.22.5"
        ports = ["http"]
      }
      logs {
        max_files     = 5
        max_file_size = 1
      }
      resources {
        
        # mostly here for the CPU chart 
        cpu    = 2000
        memory = 80 # 120MB
        # memory_max = 150 # 200MB, without this when each request is set to 10MB will OOM
      }
    }
  }
  group "load_test" {
    count = 1
    network {
      mode = "host"
    }
    restart {
      attempts = 20
      interval = "30m"
      delay = "1s"
      mode = "fail"
    }
    ephemeral_disk {
      size = 30
    }
    task "load_test" {
      driver = "docker"
      template {
        data = <<EOH
          import http from 'k6/http';
          import { sleep } from 'k6';
          export let options = {
            vus: 15,
            duration: "9000s"
          };
          export default function () {
            http.get('http://localhost:9090');
          }
        EOH
        destination = "local/script.js"
      }
      config {
        image = "loadimpact/k6:latest"
        network_mode = "host"
        volumes = [
          "local/script.js:/scripts/script.js",
        ]
        command = "run"
        args = [
          "/scripts/script.js",
        ]
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
