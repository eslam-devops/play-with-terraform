resource "aws_key_pair" "this" {
  key_name   = "blackcrow-key"
  public_key = file("~/.ssh/eslam_main_key.pub")
}
# key_pair_name = aws_key_pair.this.key_name
