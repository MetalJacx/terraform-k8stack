resource "null_resource" "vcd-cli-login" {
  provisioner "local-exec" {
    command = <<EOT
    ~/.local/bin/vcd login vpdc.phoenixnap.com ${var.vcd_org} ${var.vcd_user} --password ${var.vcd_pass} --vdc ${var.vcd_vdc} -w -i
    EOT
  }
  triggers {
      "vcd_vapp_vms" = "${vcd_vapp_vm.work.*.id}" 
  }
}

resource "vcd_inserted_media" "cp01" {
  vapp_name = "${vcd_vapp.clustername.name}"
  catalog = "${var.vcd_catalog}"
  name = "rancheros-vmware"
  vm_name = "${vcd_vapp_vm.cp.0.name}"
  eject_force = true

  provisioner "local-exec" {
    command = <<EOT
    sleep 10s;
    ~/.local/bin/vcd vapp reset -y "${vcd_vapp.clustername.name}" "${vcd_inserted_media.cp01.vm_name}"
    EOT
  }

  depends_on = ["null_resource.vcd-cli-login"]
}
resource "vcd_inserted_media" "cp02" {
  vapp_name = "${vcd_vapp.clustername.name}"
  catalog = "${var.vcd_catalog}"
  name = "rancheros-vmware"
  vm_name = "${vcd_vapp_vm.cp.1.name}"
  eject_force = true

  provisioner "local-exec" {
    command = <<EOT
    sleep 10s;
    ~/.local/bin/vcd vapp reset -y "${vcd_vapp.clustername.name}" "${vcd_inserted_media.cp01.vm_name}"
    EOT
  }  

  depends_on = ["null_resource.vcd-cli-login"]
}

resource "vcd_inserted_media" "etcd01" {
  vapp_name = "${vcd_vapp.clustername.name}"
  catalog = "${var.vcd_catalog}"
  name = "rancheros-vmware"
  vm_name = "${vcd_vapp_vm.etcd.0.name}"
  eject_force = true

  provisioner "local-exec" {
    command = <<EOT
    sleep 10s;
    ~/.local/bin/vcd vapp reset -y "${vcd_vapp.clustername.name}" "${vcd_inserted_media.cp01.vm_name}"
    EOT
  }

  depends_on = ["null_resource.vcd-cli-login"]
}
resource "vcd_inserted_media" "etcd02" {
  vapp_name = "${vcd_vapp.clustername.name}"
  catalog = "${var.vcd_catalog}"
  name = "rancheros-vmware"
  vm_name = "${vcd_vapp_vm.etcd.1.name}"
  eject_force = true

  provisioner "local-exec" {
    command = <<EOT
    sleep 10s;
    ~/.local/bin/vcd vapp reset -y "${vcd_vapp.clustername.name}" "${vcd_inserted_media.cp01.vm_name}"
    EOT
  }

  depends_on = ["null_resource.vcd-cli-login"]
}

resource "vcd_inserted_media" "etcd03" {
  vapp_name = "${vcd_vapp.clustername.name}"
  catalog = "${var.vcd_catalog}"
  name = "rancheros-vmware"
  vm_name = "${vcd_vapp_vm.etcd.2.name}"
  eject_force = true

  provisioner "local-exec" {
    command = <<EOT
    sleep 10s;
    ~/.local/bin/vcd vapp reset -y "${vcd_vapp.clustername.name}" "${vcd_inserted_media.cp01.vm_name}"
    EOT
  }  

  depends_on = ["null_resource.vcd-cli-login"]
}

resource "vcd_inserted_media" "work01" {
  vapp_name = "${vcd_vapp.clustername.name}"
  catalog = "${var.vcd_catalog}"
  name = "rancheros-vmware"
  vm_name = "${vcd_vapp_vm.work.0.name}"
  eject_force = true

  provisioner "local-exec" {
    command = <<EOT
    sleep 10s;
    ~/.local/bin/vcd vapp reset -y "${vcd_vapp.clustername.name}" "${vcd_inserted_media.cp01.vm_name}"
    EOT
  }

  depends_on = ["null_resource.vcd-cli-login"]
}
resource "vcd_inserted_media" "work02" {
  vapp_name = "${vcd_vapp.clustername.name}"
  catalog = "${var.vcd_catalog}"
  name = "rancheros-vmware"
  vm_name = "${vcd_vapp_vm.work.1.name}"
  eject_force = true
  
  provisioner "local-exec" {
    command = <<EOT
    sleep 10s;
    ~/.local/bin/vcd vapp reset -y "${vcd_vapp.clustername.name}" "${vcd_inserted_media.cp01.vm_name}"
    EOT
  }
    
  depends_on = ["null_resource.vcd-cli-login"]
}
resource "vcd_inserted_media" "work03" {
  vapp_name = "${vcd_vapp.clustername.name}"
  catalog = "${var.vcd_catalog}"
  name = "rancheros-vmware"
  vm_name = "${vcd_vapp_vm.work.2.name}"
  eject_force = true

  provisioner "local-exec" {
    command = <<EOT
    sleep 10s;
    ~/.local/bin/vcd vapp reset -y "${vcd_vapp.clustername.name}" "${vcd_inserted_media.cp01.vm_name}"
    EOT
  }

  depends_on = ["null_resource.vcd-cli-login"]
}

resource "null_resource" "vcd-cli-logoff" {
  provisioner "local-exec" {
    command = <<EOT
    ~/.local/bin/vcd logoff
    EOT
  }

  depends_on = ["vcd_inserted_media.cp01", "vcd_inserted_media.cp02", "vcd_inserted_media.etcd01", "vcd_inserted_media.etcd02", "vcd_inserted_media.etcd03", "vcd_inserted_media.work01", "vcd_inserted_media.work02", "vcd_inserted_media.work03"]
}