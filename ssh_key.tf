resource "aws_key_pair" "ssh-key" {
  key_name = "ssh-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4hrczm2sSFgeKKPXd/IGRXYJATt2k/fJ+wWD6Vij5L theo@theo-speed-demon"
}