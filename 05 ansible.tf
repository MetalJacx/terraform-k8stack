resource "null_resource" "docker-install" {
    connection {
        user = "k8admin"
    }

    provisioner "ansible" {
        
    }
  
}
