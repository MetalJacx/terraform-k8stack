resource "vcd_vapp" "clustername" {
    name = "${var.cluster_name}"
    
    depends_on = ["vcd_network_routed.work-network"]
}

resource "vcd_vapp_vm" "cp" {
    count = 1
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

resource "vcd_vapp_vm" "etcd" {
    count = 1
    vapp_name = "${vcd_vapp.clustername.name}"
    name = "${var.node_etcd}-${count.index}"
    catalog_name = "${var.vcd_catalog}"
    template_name = "${var.vcd_template}"
    memory = 4096
    cpus =  1
    cpu_cores = 1

    network_name = "${vcd_network_routed.etcd-network.name}"
    ip = "dhcp"

    depends_on = ["vcd_vapp_vm.cp"]
}

resource "vcd_vapp_vm" "work" {
    count = 1
    vapp_name = "${vcd_vapp.clustername.name}"
    name = "${var.node_work}-${count.index}"
    catalog_name = "${var.vcd_catalog}"
    template_name = "${var.vcd_template}"
    memory = 8192
    cpus =  2
    cpu_cores = 1

    network_name = "${vcd_network_routed.work-network.name}"
    ip = "dhcp"

    depends_on = ["vcd_vapp_vm.etcd"]
}