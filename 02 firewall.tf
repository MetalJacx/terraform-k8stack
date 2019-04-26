resource "vcd_firewall_rules" "Global" {
  edge_gateway = "${var.vcd_edge}"
  default_action = "drop"
  
  rule {
    description      = "ICMP"
    policy           = "allow"
    protocol         = "icmp"
    destination_port = "any"
    destination_ip   = "any"
    source_port      = "any"
    source_ip        = "any"
  }
  rule {
    description      = "DNS-udp"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "53"
    destination_ip   = "any"
    source_port      = "any"
    source_ip        = "any"
  }
  rule {
    description      = "NTP-udp"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "123"
    destination_ip   = "any"
    source_port      = "any"
    source_ip        = "any"
  }
  rule {
    description      = "SSH-JMP"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "22"
    destination_ip   = "any"
    source_port      = "any"
    source_ip        = "${var.vpn_jump_cidr}"
  }  
}

resource "vcd_firewall_rules" "cp-in" {
  edge_gateway = "${var.vcd_edge}"
  default_action = "drop"
 
  rule {
    description      = "HTTP-CP Ingress Controller"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "80"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "any"
  }
  rule {
    description      = "HTTPs-CP Ingress Controller"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "443"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "any"
  }
  rule {
    description      = "Rancher-CP Docker daemon TLS Port"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "2376"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_rancher_ip}"
  }
  rule {
    description      = "Etcd-CP k8 apiserver"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "6443"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_etcd_cidr}"
  }
  rule {
    description      = "Work-CP k8 apiserver"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "6443"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_work_cidr}"
  }
  rule {
    description      = "Etcd-CP CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_etcd_cidr}"
  }
  rule {
    description      = "Work-CP CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_work_cidr}"
  }
  rule {
    description      = "NP UDP Range CP"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "30000-32767"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "any"
  }
  rule {
    description      = "NP TCP Range CP"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "30000-32767"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "any"
  }  
}

resource "vcd_firewall_rules" "cp-out" {
  edge_gateway = "${var.vcd_edge}"
  default_action = "drop"
  
  rule {
    description      = "CP-Rancher Rancher Agent"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "443"
    destination_ip   = "${var.net_rancher_ip}"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }  
  rule {
    description      = "CP-Etcd Client and Peer Communication"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "2379-2380"
    destination_ip   = "${var.net_etcd_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }  
  rule {
    description      = "CP-Etcd CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_etcd_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }  
  rule {
    description      = "CP-Work CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_work_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }  
  rule {
    description      = "CP-Etcd Kubelet"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "10250"
    destination_ip   = "${var.net_etcd_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }  
  rule {
    description      = "CP-Work Kubelet"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "10250"
    destination_ip   = "${var.net_work_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }  
}
#These are temperary until i include proxy box
resource "vcd_firewall_rules" "snat-out" {
  edge_gateway = "${var.vcd_edge}"
  default_action = "drop"
  
  rule {
    description      = "CP-Http"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "80"
    destination_ip   = "any"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }  
  rule {
    description      = "Etcd-Http"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "80"
    destination_ip   = "any"
    source_port      = "any"
    source_ip        = "${var.net_etcd_cidr}"
  }
  rule {
    description      = "Work-Http"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "80"
    destination_ip   = "any"
    source_port      = "any"
    source_ip        = "${var.net_work_cidr}"
  }   
  rule {
    description      = "CP-Https"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "443"
    destination_ip   = "any"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }  
  rule {
    description      = "Etcd-Https"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "443"
    destination_ip   = "any"
    source_port      = "any"
    source_ip        = "${var.net_etcd_cidr}"
  }
  rule {
    description      = "Work-Https"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "443"
    destination_ip   = "any"
    source_port      = "any"
    source_ip        = "${var.net_work_cidr}"
  }   
}

#These are temperary until i include proxy box
resource "vcd_snat" "cp-out" {
  edge_gateway = "${var.vcd_edge}"
  external_ip  = "${var.net_snat_ip}"
  internal_ip  = "${var.net_cp_cidr}"
}
resource "vcd_snat" "etcd-out" {
  edge_gateway = "${var.vcd_edge}"
  external_ip  = "${var.net_snat_ip}"
  internal_ip  = "${var.net_etcd_cidr}"
}
resource "vcd_snat" "work-out" {
  edge_gateway = "${var.vcd_edge}"
  external_ip  = "${var.net_snat_ip}"
  internal_ip  = "${var.net_work_cidr}"
}

resource "vcd_firewall_rules" "etcd-in" {
  edge_gateway = "${var.vcd_edge}"
  default_action = "drop"
  
  rule {
    description      = "Rancher-Etcd Docker daemon TLS Port"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "2376"
    destination_ip   = "${var.net_etcd_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_rancher_ip}"
  }
  rule {
    description      = "CP-Etcd client and peer communication"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "2379-2380"
    destination_ip   = "${var.net_etcd_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }  
  rule {
    description      = "CP-Etcd CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_etcd_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }
  rule {
    description      = "Work-Etcd CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_etcd_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_work_cidr}"
  }
  rule {
    description      = "CP-Etcd kubelet"
    policy           = "allow"
    protocol         = "TCP"
    destination_port = "10250"
    destination_ip   = "${var.net_etcd_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }
}

resource "vcd_firewall_rules" "etcd-out" {
  edge_gateway = "${var.vcd_edge}"
  default_action = "drop"
 
  rule {
    description      = "Etcd-Rancher Rancher Agent"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "443"
    destination_ip   = "${var.net_rancher_ip}"
    source_port      = "any"
    source_ip        = "${var.net_etcd_cidr}"
  }  
  rule {
    description      = "Etcd-CP Kubernetes apiserver"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "6443"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_etcd_cidr}"
  }  
  rule {
    description      = "Etcd-CP CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_etcd_cidr}"
  }  
  rule {
    description      = "Etcd-Work CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_work_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_etcd_cidr}"
  }  
}
resource "vcd_firewall_rules" "work-in" {
  edge_gateway = "${var.vcd_edge}"
  default_action = "drop"
  
  rule {
    description      = "HTTP-Work Ingress Controller"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "80"
    destination_ip   = "${var.net_work_cidr}"
    source_port      = "any"
    source_ip        = "any"
  }
  rule {
    description      = "HTTPs-Work Ingress Controller"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "443"
    destination_ip   = "${var.net_work_cidr}"
    source_port      = "any"
    source_ip        = "any"
  }
  rule {
    description      = "Rancher-Work Docker daemon TLS Port"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "2376"
    destination_ip   = "${var.net_work_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_rancher_ip}"
  }
  rule {
    description      = "Etcd-Work CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_work_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_etcd_cidr}"
  }
  rule {
    description      = "CP-Work CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_work_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }
  rule {
    description      = "CP-Work kubelet"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "10254"
    destination_ip   = "${var.net_work_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_cp_cidr}"
  }
  rule {
    description      = "NP UDP Range WORK"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "30000-32767"
    destination_ip   = "${var.net_work_cidr}"
    source_port      = "any"
    source_ip        = "any"
  }
  rule {
    description      = "NP TCP Range WORK"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "30000-32767"
    destination_ip   = "${var.net_work_cidr}"
    source_port      = "any"
    source_ip        = "any"
  }  
}

resource "vcd_firewall_rules" "work-out" {
  edge_gateway = "${var.vcd_edge}"
  default_action = "drop"
  
  rule {
    description      = "Work-Rancher Rancher Agent"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "443"
    destination_ip   = "${var.net_rancher_ip}"
    source_port      = "any"
    source_ip        = "${var.net_work_cidr}"
  }  
  rule {
    description      = "Work-CP Client and Peer Communication"
    policy           = "allow"
    protocol         = "tcp"
    destination_port = "6443"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_work_cidr}"
  }  
  rule {
    description      = "Work-Etcd CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_etcd_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_work_cidr}"
  }  
  rule {
    description      = "Work-CP CNI VXLAN overlay"
    policy           = "allow"
    protocol         = "udp"
    destination_port = "8472"
    destination_ip   = "${var.net_cp_cidr}"
    source_port      = "any"
    source_ip        = "${var.net_work_cidr}"
  }  
}
