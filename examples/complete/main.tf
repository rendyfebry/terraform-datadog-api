locals {
  product_domain = "BEI"
  cluster        = "beical-app"
  environment    = "production"
}

provider "datadog" {
  version = "~> 3.0"
}

module "api" {
  source         = "../../"
  product_domain = local.product_domain
  service        = "beical"
  cluster        = local.cluster
  environment    = local.environment
  tags           = ["tag1", "tag2"]

  recipients         = ["bei@traveloka.com"]
  alert_recipients   = ["pagerduty-bei"]
  warning_recipients = ["slack-bei"]
  renotify_interval  = 0
  notify_audit       = false

  latency_p95_name = "${local.product_domain} - ${local.cluster} - ${local.environment} - API Latency is High"
  latency_p95_thresholds = {
    critical = 1000
    warning  = 800
  }

  latency_p95_message            = "Monitor is triggered"
  latency_p95_escalation_message = "Monitor isn't resolved for given interval"
  latency_p95_include_tags       = false

  exception_name = "${local.product_domain} - ${local.cluster} - ${local.environment} - API Exception is High"
  exception_thresholds = {
    critical = 50
    warning  = 20
  }

  exception_message            = "Monitor is triggered"
  exception_escalation_message = "Monitor isn't resolved for given interval"
  exception_include_tags       = false
}
