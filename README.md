# Automated Rancher Node Deployment in vCD

## General Information
The purpose of this was for to create a repeatable process of deploying a kubernetes cluster to be connected up with Rancher v2. 

## Tools and Referances
- [`Terraform`](https://www.terraform.io/downloads.html) - v11.3 - Installed Locally
  - [`Terraform.vCD`](https://github.com/terraform-providers/terraform-provider-vcd) - Plugin
  - [`Terraform.ansible`](https://github.com/radekg/terraform-provisioner-ansible) - Plugin
- [`Ansible`](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW#latest-releases-via-apt-ubuntu) - Installed locally

## Folder Structure

```
├── .terraform.d                                    <--- Created During Ansible Creation
│   ├── plugins
│       ├── terraform-provider-vcd_v#               <--- Terraform vCD Plugin
│       ├── terraform-provisioner-ansible_v#        <--- Terraform Ansible Plugin
|
└── Deployments
    ├── Production - Phx
    │   ├── *.tf
    │   ├── *.tfvars
    │   ├── .terrform                               <--- Create when initalized
    │   └── ansible-date                            <--- Folder Structure for [ansible](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
    │       ├── playbooks
    │       │   ├── ps_k8s.yml                      <--- Define variables and calls rolls  
    │       └── roles
    │           ├── docker
    │           │   ├── meta
    │           │   │   ├── main.yml                <--- Dependancies for roels 
    │           │   ├── tasks
    │           │   │   ├── main.yml                <--- Tasks that will Run
    │           └── <addition roles>
    ├── <Addition Deployments>
```

```
#-------------------------------------------#
# vCD Provider Info - Case Sensitive
#-------------------------------------------#
vcd_user = ""
vcd_pass = ""
vcd_org = ""
vcd_vdc = ""
vcd_url = "" #"https://domain/api"
vcd_edge = ""

#-------------------------------------------#
# Catalog Image Info
#-------------------------------------------#
vcd_catalog = ""
vcd_template = ""
vcd_template_username = ""
vcd_template_pass =  ""

#-------------------------------------------#
# Rancher Info
#-------------------------------------------#
net_rancher_ip = ""
node_run_cmd = "" #leave node role off

#-------------------------------------------#
# Cluster info
#-------------------------------------------#
cluster_name = ""
net_edge_ip = "0.0.0.0"
net_snat_ip = "0.0.0.0"

#-------------------------------------------#
# Controlplane info
#-------------------------------------------#
node_cp_cnt = 1 #1 or more
node_cp = ""
net_cp_name = ""
net_cp_cidr = "0.0.0.0/0"
net_cp_dns = {
    "DNS1" = "8.8.8.8"
    "DNS2" = "8.8.4.4"
}

#-------------------------------------------#
# Etcd info
#-------------------------------------------#
node_etcd_cnt = 1 #1, 3, or 5
node_etcd = ""
net_etcd_name = ""
net_etcd_cidr = "0.0.0.0/24"
net_etcd_dns = {
    "DNS1" = "8.8.8.8"
    "DNS2" = "8.8.4.4"
}

#-------------------------------------------#
# Worker info
#-------------------------------------------#
node_work_cnt = 1 #1 or more
node_work = ""
net_work_name = ""
net_work_cidr = "0.0.0.0/24"
net_work_dns = {
    "DNS1" = "8.8.8.8"
    "DNS2" = "8.8.4.4"
}

#-------------------------------------------#
# VPN - Connection to Rancher and JumpBox
#-------------------------------------------#
vpn_enable = "false"  # <--Do you need a VPN Connection [Default: false]?
vpn_vdc = ""
vpn_edge = ""
vpn_edge_ip = "0.0.0.0"
##Local##
vpn_rancher_cidr = "0.0.0.0/24"
vpn_jump_cidr = "0.0.0.0.0/24"
vpn_secret = ""
```
