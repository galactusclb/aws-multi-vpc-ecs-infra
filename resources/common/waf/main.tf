resource "aws_wafv2_web_acl" "this" {
  name = "WAF"
  description = "Example of a managed rule."
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name = "waf-metric"
    sampled_requests_enabled = true
  }

  lifecycle {
    ignore_changes = [rule]
  }
  
  tags = {
    Name = "internet-waf" 
  }
}

resource "aws_wafv2_web_acl_rule" "managed_common_rule" {
  name = "managed_common_rule"
  web_acl_arn = aws_wafv2_web_acl.this.arn
  priority = 3

  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesCommonRuleSet"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "common-rule"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_rule" "managed_bad_input_rule" {
  name = "managed_bad_input_rule"
  web_acl_arn = aws_wafv2_web_acl.this.arn
  priority = 2

  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name = "AWSManagedRulesKnownBadInputsRuleSet"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "bad-inputs"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_rule" "managed_ip_reputation_rule" {
  name = "managed_ip_reputation_rule"
  web_acl_arn = aws_wafv2_web_acl.this.arn
  priority = 1

  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name = "AWSManagedRulesAmazonIpReputationList"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ip-reputation"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "internet-alb" {
  web_acl_arn = aws_wafv2_web_acl.this.arn
  resource_arn = var.internet-alb-arn
}