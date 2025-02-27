output "instance_public_ip" {
description = "public ip of the instance created"
value = aws_instance.linux.public_ip
  
}

resource "local_file" "output_file" {
  content  = <<EOT
Instance Public IP: ${aws_instance.linux.public_ip}
EOT
  filename = "${path.module}/terraform-output.txt"
}