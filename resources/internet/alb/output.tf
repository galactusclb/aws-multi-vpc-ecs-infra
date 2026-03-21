output "debug_nlb_ips" {
  value = data.external.nlb_ips.result.ips
}