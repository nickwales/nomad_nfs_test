job "hello_world_no_root" {

  datacenters = [
  "dc1"
]
  type = "service"

  group "app" {
    count = 1

    network {
      port "http" {
        to = 8000
      }
    }

    volume "nfs" {
      type = "host"
      read_only = false
      source = "nfs_no_root"
    }

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "server" {
      driver = "docker"

      volume_mount {
        volume      = "nfs"
        destination = "/mnt/nfs"
      }

      config {
        image = "mnomitch/hello_world_server"
        ports = ["http"]
      }

      env {
        MESSAGE = "Hello World!"
      }
    }
  }
}
