# Create the Route53 zone for widget subdomain
resource "aws_route53_zone" "main" {
  name = "widget.agaile.com"  # Using widget subdomain
  
  tags = {
    Environment = "dev"
    ManagedBy  = "terraform"
  }
}

# ACM Validation Record
resource "aws_route53_record" "cert_validation" {
  for_each = {
    "widget.agaile.com" = {  # Updated domain to match widget subdomain
      name    = "_5471ee724dc974dca6a63ebb80029e45.widget.agaile.com"
      record  = "_9b5a0b147d579b8d064993f66d4dca33.zfyfvmchrl.acm-validations.aws."
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = "CNAME"
  zone_id         = aws_route53_zone.main.id

  lifecycle {
    prevent_destroy = true
  }
}

# Move individual ALB records to their respective tenant configurations
# The ALB records (convert10_alb, rooftopsolar, zohlar) should be removed from here
# as they are now managed in their respective tenant configurations
# For example, the record for agaile tenant is now in environments/dev/tenants/agaile/main.tf 