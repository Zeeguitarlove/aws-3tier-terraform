output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "private_subnet_id" {
  value = module.network.private_subnet_id
}

output "public_instance_ip" {
  value = module.network.public_instance_ip
}

output "private_instance_ip" {
  value = module.network.private_instance_ip
}

