variable "region_name" {
	description = "Region name for AWS EC2"
	default = "eu-west-1"
}

variable "ami_id" {
	description = "Ami id for AWS EC2"
	default = "ami-0d71ea30463e0ff8d"
}

variable "instance_type_name" {
	description = "Name instance type"
	default = "t2.micro"
}

variable "vpc_security" {
	description = "Security groups ids"
	default = ["sg-0ad91972ad61e4b70"]
}

variable "key_name_id" {
	description = "Key name pair"
	default = "sinensia2"
}

variable "subnet_id" {
	description = "Subnet id"
	default = "subnet-010e2c605995e8c9d"
}

variable "tag_name" {
	description = "Name tag"
	default = "terraformInstace"
}

variable "tag_app" {
	description = "App name"
	default = "vue2048"
}