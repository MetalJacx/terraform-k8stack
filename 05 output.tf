output "cp" {
  value = "${concat(list("${vcd_vapp_vm.cp.*.name}"), list("${vcd_vapp_vm.cp.*.ip}"))}"
}
output "etcd" {
  value = "${concat(list("${vcd_vapp_vm.etcd.*.name}"), list("${vcd_vapp_vm.etcd.*.ip}"))}"
}
output "worker" {
  value = "${concat(list("${vcd_vapp_vm.work.*.name}"), list("${vcd_vapp_vm.work.*.ip}"))}"
}