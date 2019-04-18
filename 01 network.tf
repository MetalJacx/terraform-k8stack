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

  static_ip_pool {
      start_address = "${cidrhost("${var.net_etcd_cidr}", 101)}"
      end_address = "${cidrhost("${var.net_etcd_cidr}", 150)}"
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

  static_ip_pool {
      start_address = "${cidrhost("${var.net_work_cidr}", 101)}"
      end_address = "${cidrhost("${var.net_work_cidr}", 150)}"
  }
  depends_on = ["vcd_network_routed.etcd-network"]
}

resource "vcd_edgegateway_vpn" "Dev" {
  count = "${var.vpn_enable == "true" ? 1: 0}"
  edge_gateway        = "${var.vcd_edge}"
  name                = "${var.vcd_vdc}-to-${var.vpn_vdc}"
  description         = "VPN built by terraform"
  encryption_protocol = "AES256"
  mtu                 = 1400
  peer_id             = "${var.vpn_edge_ip}"
  peer_ip_address     = "${var.vpn_edge_ip}"
  local_id            = "${var.net_edge_ip}"
  local_ip_address    = "${var.net_edge_ip}"
  shared_secret       = "${var.vpn_secret}"

  peer_subnets {
    peer_subnet_name    = "Rancher"
    peer_subnet_gateway = "${cidrhost("${var.vpn_rancher_cidr}", 1)}"
    peer_subnet_mask    = "${cidrnetmask("${var.vpn_rancher_cidr}")}"
  }

  peer_subnets {
    peer_subnet_name    = "JumpBoxes"
    peer_subnet_gateway = "${cidrhost("${var.vpn_jump_cidr}", 1)}"
    peer_subnet_mask    = "${cidrnetmask("${var.vpn_jump_cidr}")}"
  }

  local_subnets {
    local_subnet_name    = "${var.net_cp_name}"
    local_subnet_gateway = "${cidrhost("${var.net_cp_cidr}", 1)}"
    local_subnet_mask    = "${cidrnetmask("${var.net_cp_cidr}")}"
  }

  local_subnets {
    local_subnet_name    = "${var.net_etcd_name}"
    local_subnet_gateway = "${cidrhost("${var.net_etcd_cidr}", 1)}"
    local_subnet_mask    = "${cidrnetmask("${var.net_etcd_cidr}")}"
  }
  local_subnets {
    local_subnet_name    = "${var.net_work_name}"
    local_subnet_gateway = "${cidrhost("${var.net_work_cidr}", 1)}"
    local_subnet_mask    = "${cidrnetmask("${var.net_work_cidr}")}"
  }

  depends_on = ["vcd_network_routed.work-network"]
}

resource "vcd_edgegateway_vpn" "mgmt" {
  count = "${var.vpn_enable == "true" ? 1: 0}"
  vdc                 = "${var.vpn_vdc}"
  edge_gateway        = "${var.vpn_edge}"
  name                = "${var.vpn_vdc}-to-${var.vcd_vdc}"
  description         = "VPN built by terraform"
  encryption_protocol = "AES256"
  mtu                 = 1400
  peer_id             = "${var.net_edge_ip}"
  peer_ip_address     = "${var.net_edge_ip}"
  local_id            = "${var.vpn_edge_ip}"
  local_ip_address    = "${var.vpn_edge_ip}"
  shared_secret       = "${var.vpn_secret}"

  local_subnets {
    local_subnet_name    = "Rancher"
    local_subnet_gateway = "${cidrhost("${var.vpn_rancher_cidr}", 1)}"
    local_subnet_mask    = "${cidrnetmask("${var.vpn_rancher_cidr}")}"
  }

  local_subnets {
    local_subnet_name    = "JumpBoxes"
    local_subnet_gateway = "${cidrhost("${var.vpn_jump_cidr}", 1)}"
    local_subnet_mask    = "${cidrnetmask("${var.vpn_jump_cidr}")}"
  }

  peer_subnets {
    peer_subnet_name    = "${var.net_cp_name}"
    peer_subnet_gateway = "${cidrhost("${var.net_cp_cidr}", 1)}"
    peer_subnet_mask    = "${cidrnetmask("${var.net_cp_cidr}")}"
  }

  peer_subnets {
    peer_subnet_name    = "${var.net_etcd_name}"
    peer_subnet_gateway = "${cidrhost("${var.net_etcd_cidr}", 1)}"
    peer_subnet_mask    = "${cidrnetmask("${var.net_etcd_cidr}")}"
  }
  peer_subnets {
    peer_subnet_name    = "${var.net_work_name}"
    peer_subnet_gateway = "${cidrhost("${var.net_work_cidr}", 1)}"
    peer_subnet_mask    = "${cidrnetmask("${var.net_work_cidr}")}"
  }
  depends_on = ["vcd_network_routed.work-network"]
}