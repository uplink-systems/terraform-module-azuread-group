####################################################################################################
#   main.tf                                                                                        #
####################################################################################################

variable "azuread_group" {
  description = "Variable definition 'azuread_group'"
  type        = map(object({
    display_name                = string
    administrative_units        = optional(set(string), null)
    assignable_to_role          = optional(bool, false)
    auto_subscribe_new_members  = optional(bool, false)
    behaviors                   = optional(set(string), null)
    description                 = optional(string)
    dynamic_membership          = optional(object({
      enabled = bool
      rule    = string
    }), null)
    external_senders_allowed    = optional(bool, false)
    hide_from_address_lists     = optional(bool, false)
    hide_from_outlook_clients   = optional(bool, false)
    mail_enabled                = optional(bool, false)
    mail_nickname               = optional(string, null)
    member_groups               = optional(set(string), [])
    member_service_principals   = optional(set(string), [])
    member_users                = optional(set(string), [])
    onpremises_group_type       = optional(string, "UniversalSecurityGroup")
    owners                      = optional(set(string), [])
    prevent_duplicate_names     = optional(bool, true)
    provisioning_options        = optional(set(string), null)
    security_enabled            = optional(bool, true)
    theme                       = optional(string, null)
    types                       = optional(list(string), null)
    visibility                  = optional(string, null)
    writeback_enabled           = optional(bool, false)
  }))
  default = {
    "AAD-Terraform-Security_Assigned" = {
      display_name          = "AAD-Terraform-Security_Assigned"
      description           = "AAD-Terraform-Security_Assigned group"
      member_groups         = [
      ]
      member_users          = [
        "user.01@company.onmicrosoft.com",
        "user.02@company.onmicrosoft.com",
      ]
    }
    "AAD-Terraform-Security_Dynamic" = {
      display_name          = "AAD-Terraform-Security_Dynamic"
      description           = "AAD-Terraform-Security_Dynamic group"
      assignable_to_role    = false
      dynamic_membership = {
        enabled             = true
        rule                = "(user.accountEnabled -eq true) and (user.companyName -eq \"company.onmicrosoft.com\")"
      }
      types                 = [
        "DynamicMembership",
      ]
    }
    "AAD-Terraform-Unified_Assigned" = {
      display_name          = "AAD-Terraform-Unified_Assigned"
      description           = "AAD-Terraform-Unified_Assigned group"
      behaviors             = [
        "HideGroupInOutlook",
        "SubscribeNewGroupMembers",
        "WelcomeEmailDisabled",
      ]
      mail_enabled          = true
      mail_nickname         = "AAD-Terraform-Unified_Assigned"
      member_groups         = [
      ]
      member_users          = [
        "user.01@company.onmicrosoft.com",
      ]
      types                 = [
        "Unified",
      ]
    }
    "AAD-Terraform-Unified_Dynamic" = {
      display_name          = "AAD-Terraform-Unified_Dynamic"
      description           = "AAD-Terraform-Unified_Dynamic group"
      behaviors             = [
        "HideGroupInOutlook",
        "SubscribeNewGroupMembers",
        "WelcomeEmailDisabled",
      ]
      mail_nickname         = "AAD-Terraform-Unified_Dynamic"
      dynamic_membership = {
        enabled             = true
        rule                = "(user.accountEnabled -eq true) and (user.companyName -eq \"company.onmicrosoft.com\")"
      }
      mail_enabled          = true
      owners                = [
        "administrator@company.onmicrosoft.com",
      ]
      provisioning_options  = ["Team"]
      types                 = [
        "DynamicMembership",
        "Unified",
      ]
    }
  }
}

module "azuread_group" {
  source                      = "github.com/uplink-systems/Terraform-Modules//modules/azuread/group"
  for_each                    = var.azuread_group
  display_name                = each.value.display_name
  administrative_units        = each.value.administrative_units
  assignable_to_role          = each.value.assignable_to_role
  auto_subscribe_new_members  = each.value.auto_subscribe_new_members
  behaviors                   = each.value.behaviors
  description                 = each.value.description
  dynamic_membership          = each.value.dynamic_membership
  external_senders_allowed    = each.value.external_senders_allowed
  hide_from_address_lists     = each.value.hide_from_address_lists
  hide_from_outlook_clients   = each.value.hide_from_outlook_clients
  mail_enabled                = each.value.mail_enabled
  mail_nickname               = each.value.mail_nickname
  member_groups               = each.value.member_groups
  member_service_principals   = each.value.member_service_principals
  member_users                = each.value.member_users
  onpremises_group_type       = each.value.onpremises_group_type
  owners                      = each.value.owners
  prevent_duplicate_names     = each.value.prevent_duplicate_names
  provisioning_options        = each.value.provisioning_options
  security_enabled            = each.value.security_enabled
  theme                       = each.value.theme
  types                       = each.value.types
  visibility                  = each.value.visibility
  writeback_enabled           = each.value.writeback_enabled
}