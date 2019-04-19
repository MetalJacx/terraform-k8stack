# terraform-k8stack

```
#-------------------------------------------#
# vCD Provider Info
#-------------------------------------------#
vcd_user = ""
vcd_pass = ""
vcd_org = ""
vcd_vdc = "CNT-QA"
vcd_url = ""
vcd_edge = "Edge_CNT_QA"
vcd_catalog = "JB-Catalog"
vcd_template = "k8s-clus-sm"


#-------------------------------------------#
# VPN - Connection to Rancher and JumpBox
#-------------------------------------------#
vpn_enable = "true"  # <--Do you need a VPN Connection [Default: false]?
vpn_vdc = ""
vpn_edge = ""
vpn_edge_ip = ""
##Local##
vpn_rancher_cidr = ""
vpn_jump_cidr = ""
vpn_secret = ""

#-------------------------------------------#
# Rancher Info
#-------------------------------------------#
net_rancher_ip = ""

#-------------------------------------------#
# Cluster info
#-------------------------------------------#
cluster_name = "Dev k8"
net_edge_ip = ""
net_snat_ip = ""


#-------------------------------------------#
# Controlplane info
#-------------------------------------------#
node_cp = "k8-test-cp"
net_cp_name = "R1_k8_cp"
net_cp_cidr = "10.210.0.0/24"
net_cp_dns = {
    "DNS1" = "8.8.8.8"
    "DNS2" = "8.8.4.4"
}

#-------------------------------------------#
# Etcd info
#-------------------------------------------#
node_etcd = "k8-test-etcd"
net_etcd_name = "R2_k8_etcd"
net_etcd_cidr = "10.211.0.0/24"
net_etcd_dns = {
    "DNS1" = "8.8.8.8"
    "DNS2" = "8.8.4.4"
}

#-------------------------------------------#
# Worker info
#-------------------------------------------#
node_work = "k8-test-work"
net_work_name = "R3_k8_work"
net_work_cidr = "10.212.0.0/24"
net_work_dns = {
    "DNS1" = "8.8.8.8"
    "DNS2" = "8.8.4.4"
}
```
