output "sg_id" {
  value = aws_security_group.ec2_sg.id
}

#output "key_name" {
#  value = aws_key_pair.ssh_key.key_name
#}

output "iam_role_arn" {
  value = aws_iam_role.ec2_role.arn
}
