job "load_test" {
  datacenters = ["dc1"]
  type = "service"

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
            vus: 10,
            duration: '900s',
          };
          export default function () {
            http.get('http://api-service.consul:9090');
            sleep(1);
          }
        EOH

        destination = "local/script.js"
      }

      config {
        image = "loadimpact/k6:latest"

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