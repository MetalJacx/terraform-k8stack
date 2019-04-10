resource "null_resource" "cloudconfig-cp" {
  count = 2

  connection {
      type = "ssh"
      host = "${vcd_vapp_vm.cp.*.ip}"
  }

  provisioner "local-exec" {
      command = <<EOT
      touch "${var.node_cp}-${count.index}".yml;
      echo "ssh_authorized_keys:" > "${var.node_cp}-${count.index}".yml;
      echo "  - ssh-rsa ${var.ssh_rsa}" >> "${var.node_cp}-${count.index}".yml;
      echo "hostname: ${var.node_cp}-${count.index}" >> "${var.node_cp}-${count.index}".yml
      EOT
  }

  provisioner "file" {
      source = "${var.node_cp}-${count.index}.yml"
      destination = "/home/rancher/cloud-config.yml"
  }

  provisioner "remote-exec"{
      inline = [
          "sudo ros install cloud-config.yml -f"
      ]      
  }
}
