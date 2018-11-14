provider "linode" {
  token = "${var.token}"
}

data "linode_region" "main" {
  id = "${var.region}"
}


data "linode_instance_type" "default" {
  id = "g6-nanode-1"
}

data "linode_image" "ubuntu" {
  id = "linode/ubuntu18.04"
}
	
resource "linode_instance" "mosquitto" {
  count = "${var.count}"
  label = "${var.projectName}-Node-${count.index + 1}"
  type = "${data.linode_instance_type.default.id}"
  region = "${data.linode_region.main.id}"
  image = "${data.linode_image.ubuntu.id}"
  group = "${var.projectName}"
  authorized_keys = ["${chomp(file(var.ssh_key))}"]
  root_pass = "${var.root_pass}"
  private_ip = true
  provisioner "remote-exec" {
    inline = [
      # install mosquitto
      "export PATH=$PATH:/usr/bin",
      "apt-get install -y software-properties-common",
      "apt-add-repository -y ppa:mosquitto-dev/mosquitto-ppa",
      "apt-get -y update",
      "apt-get install -y mosquitto",
      "apt-get install -y mosquitto-clients",

    ]
    connection {
        type     = "ssh",
        user     = "root",
        agent = "false",
        private_key = "${file("~/.ssh/id_rsa")}",
  }  
}
}

resource "linode_nodebalancer" "mosquittolb" {
  label                = "${var.projectName}"
  region               = "${data.linode_region.main.id}"
  client_conn_throttle = 0
}

resource "linode_nodebalancer_config" "mosquittolbconfig" {
  port            = 1883
  nodebalancer_id = "${linode_nodebalancer.mosquittolb.id}"
  protocol        = "http"
  algorithm       = "source"
  stickiness      = "none"
  check_interval  = "90"	#Seconds between health check probes
  check_timeout   = "10"	#Seconds to wait before considering the probe a failure. 1-30. Must be less than check_interval.
  check_attempts  = "3"		#Number of failed probes before taking a node out of rotation. 1-30
}

resource "linode_nodebalancer_node" "mosquittolbnode" {
  count           = "${var.count}"
  nodebalancer_id = "${linode_nodebalancer.mosquittolb.id}"
  config_id       = "${linode_nodebalancer_config.mosquittolbconfig.id}"
  label           = "mosquitto_${count.index}"

  address = "${element(linode_instance.mosquitto.*.private_ip_address, count.index)}:1883"
  weight  = 50
  mode    = "accept"
}

