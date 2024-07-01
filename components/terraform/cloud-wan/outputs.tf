output "global_network_arn" {
  value = awscc_networkmanager_global_network.this.arn
}

output "global_network_id" {
  value = awscc_networkmanager_global_network.this.id
}

output "core_network_arn" {
  value = awscc_networkmanager_core_network.this.core_network_arn
}

output "core_network_id" {
  value = awscc_networkmanager_core_network.this.id
}

output "core_network_policy_document" {
  value = awscc_networkmanager_core_network.this.policy_document
}
