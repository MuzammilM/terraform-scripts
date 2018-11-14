output "Mosquitto IPs" {
  value = "${join(",", linode_instance.mosquitto.*.ip_address)}"
}
