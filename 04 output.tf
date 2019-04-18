resource "null_resource" "delay" {
  provisioner "local-exec"{
    command = "sleep 60s"
  }
  depends_on = ["vcd_vapp_vm.work"]

}

output "cp" {
  value = "${concat(vcd_vapp_vm.cp.*.name, vcd_vapp_vm.cp.*.ip)}"

  depends_on = ["null_resource.delay"]
}
output "etcd" {
  value = "${concat(vcd_vapp_vm.etcd.*.name, vcd_vapp_vm.etcd.*.ip)}"

  depends_on = ["null_resource.delay"]
}
output "worker" {
  value = "${concat(vcd_vapp_vm.work.*.name, vcd_vapp_vm.work.*.ip)}"

  depends_on = ["null_resource.delay"]
}