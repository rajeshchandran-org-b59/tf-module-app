resource "aws_instance" "main" {

  ami                    = data.aws_ami.main.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "${var.name}-${var.env}"
  }
}

resource "null_resource" "main" {
  depends_on = [aws_route53_record.main] # This ensure, provisioner will only be exectued post dns_record creation
  triggers = {
    timestamp = timestamp() # Forces execution on every apply
  }

  connection {
    type     = "ssh"
    user     = data.vault_generic_secret.ssh.data["ssh_user"]
    password = data.vault_generic_secret.ssh.data["ssh_pass"]
    host     = aws_instance.main.private_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "ansible-pull -U https://github.com/rajeshchandran-org-b59/ansible.git -e env=${var.env} -e component=${var.name} -e token=${var.token} expense-pull.yaml"
    ]
  }
}