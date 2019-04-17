resource "null_resource" "docker-install" {
    connection {
        user = "k8admin"
        password = "G0ldm00n!"
    }
    provisioner "ansible" {
        plays {
            playbook = {
                file_path = "install_docker.yml"
            }
        hosts = ["vcd_vapp_vm.cp.*.ip"]
        }
    }
    depends_on = ["null_resource.delay"]
}
