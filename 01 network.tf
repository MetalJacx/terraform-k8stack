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
}

resource "vcd_network_routed" "etcd-network" {
  name = "${var.net_etcd_name}"
  edge_gateway = "${var.vcd_edge}"
  gateway = "${cidrhost("${var.net_etcd_cidr}", 1)}"
  dns1 = "${lookup("${var.net_etcd_dns}", "DNS1", "208.67.222.222")}"
  dns2 = "${lookup("${var.net_etcd_dns}", "DNS2", "1.1.1.1")}"

  dhcp_pool {
      start_address = "${cidrhost("${var.net_etcd_cidr}", 11)}"
      end_address = "${cidrhost("${var.net_etcd_cidr}", 100)}"
  }
  depends_on = ["vcd_network_routed.cp-network"]
}

resource "vcd_network_routed" "work-network" {
  name = "${var.net_work_name}"
  edge_gateway = "${var.vcd_edge}"
  gateway = "${cidrhost("${var.net_work_cidr}", 1)}"
  dns1 = "${lookup("${var.net_work_dns}", "DNS1", "208.67.222.222")}"
  dns2 = "${lookup("${var.net_work_dns}", "DNS2", "1.1.1.1")}"

  dhcp_pool {
      start_address = "${cidrhost("${var.net_work_cidr}", 11)}"
      end_address = "${cidrhost("${var.net_work_cidr}", 100)}"
  }
  depends_on = ["vcd_network_routed.etcd-network"]
}