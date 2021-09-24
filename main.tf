locals {
  monitor_enabled = "${var.enabled && length(var.recipients) > 0 ? 1 : 0}"
}

resource "datadog_timeboard" "api" {
  count = "${var.enabled ? 1 : 0}"

  title       = "${var.product_domain} - ${var.cluster} - ${var.environment} - API"
  description = "A generated timeboard for API"

  template_variable {
    default = "${var.cluster}"
    name    = "cluster"
    prefix  = "cluster"
  }

  template_variable {
    default = "${var.environment}"
    name    = "environment"
    prefix  = "environment"
  }

  template_variable {
    default = "*"
    name    = "classname"
    prefix  = "classname"
  }

  template_variable {
    default = "*"
    name    = "methodname"
    prefix  = "methodname"
  }

  graph {
    title     = "API Request Count"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "sum:api.req.count{$cluster, $environment} by {host, classname, methodname}"
      type = "line"
    }
  }

  graph {
    title     = "API Response Count"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "sum:api.res.count{$cluster, $environment} by {host, classname, methodname}"
      type = "line"
    }
  }

  graph {
    title     = "API Response Latency 95th Percentile"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "sum:api.res.ltcy.p95{$cluster, $environment} by {host, classname, methodname}"
      type = "line"
    }
  }

  graph {
    title     = "API Response Exception Count"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "sum:api.res.exc.count{$cluster, $environment} by {host, classname, methodname}"
      type = "line"
    }
  }
}

module "monitor_latency_p95" {
  source  = "github.com/traveloka/terraform-datadog-monitor?ref=v0.1.8"
  enabled = "${local.monitor_enabled}"

  product_domain = "${var.product_domain}"
  service        = "${var.service}"
  environment    = "${var.environment}"
  tags           = "${var.tags}"
  timeboard_id   = "${join(",", datadog_timeboard.api.*.id)}"

  name               = "${var.latency_p95_name != "" ? 
                        "${var.latency_p95_name}" :
                        "${var.product_domain} - ${var.cluster} - ${var.environment} - API Latency is High on Class: {{ classname }} Method: {{ methodname }}"}"
  query              = "${coalesce(var.api_latency_p95_custom_query, "avg(last_1m):avg:api.res.ltcy.p95{cluster:${var.cluster}, environment:${var.environment}} by {host,classname,methodname} >= ${var.latency_p95_thresholds["critical"]}")}"
  thresholds         = "${var.latency_p95_thresholds}"
  message            = "${var.latency_p95_message}"
  escalation_message = "${var.latency_p95_escalation_message}"

  recipients         = "${var.recipients}"
  alert_recipients   = "${var.alert_recipients}"
  warning_recipients = "${var.warning_recipients}"

  renotify_interval = "${var.renotify_interval}"
  notify_audit      = "${var.notify_audit}"
  include_tags      = "${var.latency_p95_include_tags}"
}

module "monitor_exception" {
  source  = "github.com/traveloka/terraform-datadog-monitor?ref=v0.1.8"
  enabled = "${local.monitor_enabled}"

  product_domain = "${var.product_domain}"
  service        = "${var.service}"
  environment    = "${var.environment}"
  tags           = "${var.tags}"
  timeboard_id   = "${join(",", datadog_timeboard.api.*.id)}"

  name               = "${var.exception_name != "" ? 
                        "${var.exception_name}" :
                        "${var.product_domain} - ${var.cluster} - ${var.environment} - API Exception is High on Class: {{ classname }} Method: {{ methodname }}"}"
  query              = "${coalesce(var.api_exception_custom_query, "avg(${var.monitor_exception_time_evaluation}):sum:api.res.exc.count{cluster:${var.cluster}, environment:${var.environment}} by {host,classname,methodname} >= ${var.exception_thresholds["critical"]}")}"
  thresholds         = "${var.exception_thresholds}"
  message            = "${var.exception_message}"
  escalation_message = "${var.exception_escalation_message}"

  recipients         = "${var.recipients}"
  alert_recipients   = "${var.alert_recipients}"
  warning_recipients = "${var.warning_recipients}"

  renotify_interval = "${var.renotify_interval}"
  notify_audit      = "${var.notify_audit}"
  include_tags      = "${var.exception_include_tags}"
}
