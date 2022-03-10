job "hello_world_no_root_batch" {

  datacenters = [
  "dc1"
]
  type = "batch"

  group "app" {
    count = 1

    volume "nfs" {
      type = "host"
      read_only = false
      source = "nfs_no_root"
    }

    // restart {
    //   attempts = 2
    //   interval = "30m"
    //   delay = "15s"
    //   mode = "fail"
    // }

    task "server" {
      driver = "exec"

      volume_mount {
        volume      = "nfs"
        destination = "/mnt/nfs"
      }

      config {
        command = "/bin/ls"
        args = ["-la", "/mnt/nfs"]
      }
    }
  }
}
