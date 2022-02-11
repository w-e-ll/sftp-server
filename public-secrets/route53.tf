resource "aws_route53_zone" "sftp-urls" {
  name = "apis.dealertrack.com"
}

resource "aws_route53_record" "sftp-uat" {
  zone_id = aws_route53_zone.sftp-urls.zone_id
  name    = "sftp-uat"
  type    = "CNAME"
  ttl     = "60"

  weighted_routing_policy {
    weight = 90
  }

  set_identifier = "sftp-uat"
  records        = [aws_transfer_server.sftp-server.endpoint]
}

resource "aws_route53_record" "sftp-prod" {
  zone_id = aws_route53_zone.sftp-urls.zone_id
  name    = "sftp"
  type    = "CNAME"
  ttl     = "60"

  weighted_routing_policy {
    weight = 90
  }
  set_identifier = "sftp"
  records        = [aws_transfer_server.sftp-server.endpoint]
}
