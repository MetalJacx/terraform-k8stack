resource "null_resource" "delay" {
  provisioner "local-exec"{
    command = "sleep 60s"
  }

  depends_on = ["null_resource.vcd-cli-logoff"]
}


output "cp" {
  value = "${concat(list("${vcd_vapp_vm.cp.*.name}"), list("${vcd_vapp_vm.cp.*.ip}"))}"

  depends_on = ["null_resource.delay"]
}
output "etcd" {
  value = "${concat(list("${vcd_vapp_vm.etcd.*.name}"), list("${vcd_vapp_vm.etcd.*.ip}"))}"

  depends_on = ["null_resource.delay"]
}
output "worker" {
  value = "${concat(list("${vcd_vapp_vm.work.*.name}"), list("${vcd_vapp_vm.work.*.ip}"))}"

  depends_on = ["null_resource.delay"]
}