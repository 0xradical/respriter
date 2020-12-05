output "address" {
  value = "${aws_elb.web.dns_name}"
}

output "name" {
  value = var.cloudflare_zone
}