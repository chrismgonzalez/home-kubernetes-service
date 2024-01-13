
resource "local_file" "worker_patch" {
  content = templatefile("${path.module}/templates/worker.patch.yaml.tpl",
    merge(var.kubernetes, {
      lbv4        = local.ipv4_vip
      nodeSubnets = var.vpc_main_cidr
      labels      = "gonzolab.io/node-pool=worker"
    })
  )

  filename        = "${path.module}/templates/worker.patch.yaml"
  file_permission = "0600"
}