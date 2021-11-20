#resource "aws_ec2_client_vpn_endpoint" "vpn_endpoint" {
#  description = "vpn-endpoint"
#  server_certificate_arn = "arn:aws:acm:eu-central-1:176502011080:certificate/5045ce00-8252-4005-a1b8-bc16a024b778"
#  client_cidr_block = "10.0.48.0/20"

#  authentication_options {
#    type = "certificate-authentication"
#    root_certificate_chain_arn = "arn:aws:acm:eu-central-1:176502011080:certificate/c055067d-fb07-4dcd-a30b-d2329bddd67a"
#  }

#  connection_log_options {
#    enabled = false
#  }
#}

#resource "aws_ec2_client_vpn_network_association" "vpn_to_private_association" {
#  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
#  subnet_id = aws_subnet.private.id
#}

#resource "aws_ec2_client_vpn_authorization_rule" "default_vpn_authorization_rule" {
#  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
#  target_network_cidr = aws_subnet.private.cidr_block
#  authorize_all_groups = true
#}