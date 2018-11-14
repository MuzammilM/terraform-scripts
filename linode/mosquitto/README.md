# Mosquitto infrastructure with Load balancing on Linode 

* Navigate to project folder
	* `cd mpulse_terraform/linodeProvisioner/mosquitto`

* To begin create a file called secrets.tf

`	variable "token" {
 	description = "Terraform deployment tokens"
	default     = "<Insert deployment token here>"
	}`

* Initialize the project
	* `terraform init`

* Display the changes that will be applied
	* `terraform plan`

* Create the infrastructure
	* `terraform apply`

* User input required for
	* Number of mosquitto servers to setup
	* Domain name to be assigned to the nodebalancer
		* Assumes a domain name is already setup.
		* Instructions to get the id for domain name listed below.
	* Root password for the linode servers.
	

## Get list of domains

* Setup linode-cli 
	* `pip install linode-cli`

* Get list of domains 
	* `linode-cli.exe domains list`

