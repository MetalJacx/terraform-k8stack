resource "vcd_vapp" "clustername" {
    name = "${var.cluster_name}"
    
    depends_on = ["vcd_network_routed.work-network"]
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
    ip = "allocated"

    provisioner "local-exec" {
      command = <<EOT
      sleep 60s;
      echo '${self.ip}';
      EOT
    }

    connection {
        host = "${self.ip}"
        user = "k8admin"
        password = "G0ldm00n!"
    }

    provisioner "remote-exec" {
        inline = [
            "echo hello world"
        ]
    }

    provisioner "ansible" {
      plays {
          playbook = {
              file_path = "${path.module}/ansible-data/playbooks/ps_k8s.yml"
              roles_path = ["${path.module}/ansible-data/roles"]
          }
          hosts = ["installdockeroncp"]
          extra_vars = {
              extra = {
                  variables = {
                      ansible_become_pass = "G0ldm00n!"
                  }
              }
          }    
          verbose = true
      }
      ansible_ssh_settings {
          insecure_no_strict_host_key_checking = "true"
      }
      
    }
    
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
    ip = "allocated"

    provisioner "local-exec" {
      command = <<EOT
      sleep 180s;
      echo '${self.ip}';
      EOT
    }

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
    ip = "allocated"

    provisioner "local-exec" {
      command = <<EOT
      sleep 180s;
      echo '${self.ip}';
      EOT
    }
    
    depends_on = ["vcd_vapp_vm.etcd"]
}