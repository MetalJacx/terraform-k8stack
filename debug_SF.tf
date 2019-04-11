provider "vcd" {
  user = "${var.vcd_user}"
  password = "${var.vcd_pass}"
  org = "${var.vcd_org}"
  url = "${var.vcd_url}"
  vdc = "${var.vcd_vdc}"
  max_retry_timeout = "${var.vcd_max_retry_timeout}"
}

resource "vcd_network_routed" "cp-network" {
  name = "${var.net_cp_name}"
  edge_gateway = "${var.vcd_edge}"
  gateway = "${cidrhost("${var.net_cp_cidr}", 1)}"
  dns1 = "${lookup("${var.net_cp_dns}", "DNS1", "208.67.222.222")}"
  dns2 = "${lookup("${var.net_cp_dns}", "DNS2", "1.1.1.1")}"

  dhcp_pool {
      start_address = "${cidrhost("${var.net_cp_cidr}", 11)}"
      end_address = "${cidrhost("${var.net_cp_cidr}", 100)}"
  }

  static_ip_pool {
      start_address = "${cidrhost("${var.net_cp_cidr}", 101)}"
      end_address = "${cidrhost("${var.net_cp_cidr}", 150)}"
  }
}

resource "vcd_vapp" "clustername" {
    name = "${var.cluster_name}"
    
    depends_on = ["vcd_network_routed.cp-network"]
}

resource "vcd_vapp_vm" "cp" {
    count = 2
    vapp_name = "${vcd_vapp.clustername.name}"
    name = "${var.node_cp}-${count.index}"
    catalog_name = "${var.vcd_catalog}"
    template_name = "${var.vcd_template}"
    memory = 4096
    cpus =  1
    cpu_cores = 1

    network_name = "${vcd_network_routed.cp-network.name}"
    ip = "dhcp"

    depends_on = ["vcd_vapp.clustername"]
}

resource "null_resource" "vcd-cli-login" {
  provisioner "local-exec" {
    when = "create"
    command = <<EOT
    ~/.local/bin/vcd login vpdc.phoenixnap.com ${var.vcd_org} ${var.vcd_user} --password ${var.vcd_pass} --vdc ${var.vcd_vdc} -w -i
    EOT
  }

  depends_on = ["vcd_vapp_vm.cp"]
}

resource "vcd_inserted_media" "cp01" {
  vapp_name = "${vcd_vapp.clustername.name}"
  catalog = "${var.vcd_catalog}"
  name = "rancheros-vmware"
  vm_name = "${vcd_vapp_vm.cp.0.name}"
  eject_force = true

  provisioner "local-exec" {
    when = "create"
    command = <<EOT
    sleep 10s;
    ~/.local/bin/vcd vapp reset -y "${vcd_vapp.clustername.name}" "${vcd_inserted_media.cp01.vm_name}"
    EOT
  }

  depends_on = ["null_resource.vcd-cli-login"]
}

resource "null_resource" "vcd-cli-logoff" {
  provisioner "local-exec" {
    when = "create"
    command = <<EOT
    ~/.local/bin/vcd logout
    EOT
  }

  depends_on = ["vcd_inserted_media.cp01", "vcd_inserted_media.cp02"]
}
