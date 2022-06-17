variable "name_prefix" {
  default     = "TF-postgres"
  description = "Prefix of the resource name."
}

#location for creation

variable "location" {
  default = "North Central US"
  type    = string
}

# resource group name

variable "rsg_name" {
  type    = string
  default = "Week5-TF-VMss-bonus"
}


#variable for network range

variable "node_address_space" {
  #  type    = list(string)
  default = ["10.0.0.0/16"]
}

#variable for app subnet range

variable "node_address_prefix" {
  #  type    = list(string)
  default = ["10.0.0.0/24"]
}

variable "application_port" {
  description = "Port that you want to expose to the external load balancer"
  default     = 8080
}

#variable for db subnet range

variable "db_address_prefix" {
  #  type    = list(string)
  default = ["10.0.1.0/24"]
}


#variable for Environment
variable "Environment" {
  type    = string
  default = "test"
}

#variables for image

variable "image_version_name" {
  default = "0.0.1"
  type    = string
}

variable "image_name" {
  default = "avsha_app_001"
  type    = string
}

variable "image_gallery_name" {
  default = "avsha"
  type    = string
}

variable "image_resource_group_name" {
  default = "image"
  type    = string
}



