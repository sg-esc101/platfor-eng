output "vm_public_ip" {
  description = "Public IP of the VM from compute module"
  value       = module.compute.vm_public_ip
}
