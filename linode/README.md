## Mosquitto infrastructure with Load balancing on Linode

* To begin create a file called secrets.tf

`       variable "token" {
        description = "Linode deployment tokens"
        default     = "<Insert deployment token here>"
        }`
