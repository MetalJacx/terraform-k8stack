resource "null_resource" "cloud-config.yml" {
  provisioner "local-exec" {
      command = <<EOT
      touch cloud-config.yml;
      echo "ssh_authorized_keys:" > cloud-config.yml;
      echo "  - ssh-rsa ${var.ssh_rsa}" >> cloud-config.yml
      EOT
  }
}
