#Provider Info
vcd_user = "****"
vcd_pass = "*****"
vcd_org = "*****"
vcd_vdc = "***"
vcd_url = "********"
vcd_edge = "*******"
vcd_catalog = "********"
vcd_template = "**********"

#Rancher Infor
net_rancher_ip = "10.148.0.11"

#cluster info
cluster_name = "dev k8"
net_snat_ip = "108.170.46.75"

#controlplane info
node_cp = "k8-test-cp"
net_cp_name = "R1_k8_cp"
net_cp_cidr = "10.200.0.0/24"
net_cp_dns = {
    "DNS1" = "8.8.8.8"
    "DNS2" = "8.8.4.4"
}

#etcd info
node_etcd = "k8-test-etcd"
net_etcd_name = "R2_k8_etcd"
net_etcd_cidr = "10.201.0.0/24"
net_etcd_dns = {
    "DNS1" = "8.8.8.8"
    "DNS2" = "8.8.4.4"
}

#worker info
node_work = "k8-test-work"
net_work_name = "R3_k8_work"
net_work_cidr = "10.202.0.0/24"
net_work_dns = {
    "DNS1" = "8.8.8.8"
    "DNS2" = "8.8.4.4"
}
