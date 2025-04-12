data "aws_route53_zone" "main" {
  name         = "rajeshapps.site"
  private_zone = false
}

# data "aws_ami" "main" {
#   most_recent = true

#   owners = ["355449129696"]
#   tags = {
#     Name = "DevOps-LabImage-RHEL9"
#   }
# }

# Once you make your own ami using the lab image with Ansible installation
data "aws_ami" "main" {
  most_recent = true

  owners = ["self"]
  tags = {
    Name = "b59-LabImage-Rajesh"
  }
}

data "vault_generic_secret" "ssh" {
  path = "expense-dev/ssh_cred"
}