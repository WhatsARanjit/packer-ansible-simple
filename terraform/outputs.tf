output "public_dns" {
  value = aws_instance.webserver.public_dns
}

output "hcp_bucket_id" {
  value = data.hcp_packer_iteration.test.ulid
}

output "hcp_ami_id" {
  value = data.hcp_packer_image.nginx.cloud_image_id
}
