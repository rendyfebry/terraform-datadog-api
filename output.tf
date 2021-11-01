output "timeboard_title" {
  value       = join(",", datadog_dashboard.api.*.title)
  description = "The title of datadog timeboard for API"
}

output "monitor_latency_p95_name" {
  value       = module.monitor_latency_p95.name
  description = "The name of datadog monitor for API Latency"
}

output "monitor_exception_name" {
  value       = module.monitor_exception.name
  description = "The name of datadog monitor for API Exception"
}
