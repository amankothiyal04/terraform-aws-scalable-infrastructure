# Launch EC2 instance
resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
              systemctl start nginx
              echo "Hello from Terraform EC2 in ${var.tags["Env"]}" > /var/www/html/index.html
              EOF

  tags = merge(var.tags, {
    Name = "Terraform-EC2"
  })
}

# IAM instance profile to attach IAM Role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = var.iam_role_arn != "" ? element(split("/", var.iam_role_arn), length(split("/", var.iam_role_arn)) - 1) : ""
}
