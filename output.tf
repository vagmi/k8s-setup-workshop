output "control_ip" {
  value = digitalocean_droplet.control.ipv4_address
}
output "worker_ips" {
  value = digitalocean_droplet.worker.*.ipv4_address
}
