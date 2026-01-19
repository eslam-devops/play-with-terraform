# main.tf
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"] # Amazon Linux 2023 owner ID

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# # في ملف main.tf
# resource "tls_private_key" "this" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "this" {
#   key_name   = "blackcrow-key-pair" # اسم ملف المفتاح
#   public_key = tls_private_key.this.public_key_openssh
# }

# # حفظ المفتاح الخاص محليًا
# resource "local_file" "private_key" {
#   filename        = "blackcrow-key-pair.pem"
#   content         = tls_private_key.this.private_key_pem
#   file_permission = "0400" # صلاحيات أمنية للملف
# }


resource "aws_instance" "this" {
  ami                     = data.aws_ami.amazon_linux.id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  iam_instance_profile    = var.iam_instance_profile_name
  key_name                = var.key_pair_name
  vpc_security_group_ids  = var.security_group_ids
  user_data               = var.user_data
  disable_api_termination = var.disable_api_termination
  monitoring              = var.monitoring

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  tags = merge(
    {
      Name = var.name
    },
    var.additional_tags
  )
}

