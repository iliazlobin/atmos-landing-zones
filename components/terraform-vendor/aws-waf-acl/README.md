# Component: `aws-waf-acl`

This component is responsible for provisioning an AWS Web Application Firewall (WAF) with an associated managed rule group.


## Usage

**Stack Level**: Regional

Here's an example snippet for how to use this component.

```yaml
components:
  terraform:
    aws-waf-acl:
      vars:
        enabled: true
        acl_name: default
        default_action: allow
        description: Default web ACL
        managed_rule_group_statement_rules:
        - name: "OWASP-10"
          # Rules are processed in order based on the value of priority, lowest number first
          priority: 1

          statement:
            name:  AWSManagedRulesCommonRuleSet
            vendor_name: AWS

          visibility_config:
            # Defines and enables Amazon CloudWatch metrics and web request sample collection.
            cloudwatch_metrics_enabled: false
            metric_name: "OWASP-10"
            sampled_requests_enabled: false
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.14.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.36 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.1 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | ~> 0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.36 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_waf"></a> [aws\_waf](#module\_aws\_waf) | cloudposse/waf/aws | 0.0.1 |
| <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles) | ../account-map/modules/iam-roles | n/a |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.acl_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl_name"></a> [acl\_name](#input\_acl\_name) | Friendly name of the ACL. The ACL ARN will be stored in SSM under {ssm\_path\_prefix}/{acl\_name}/arn | `string` | n/a | yes |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_association_resource_arns"></a> [association\_resource\_arns](#input\_association\_resource\_arns) | A list of ARNs of the resources to associate with the web ACL.<br>This must be an ARN of an Application Load Balancer or an Amazon API Gateway stage. | `list(string)` | `[]` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_byte_match_statement_rules"></a> [byte\_match\_statement\_rules](#input\_byte\_match\_statement\_rules) | A rule statement that defines a string match search for AWS WAF to apply to web requests.<br><br>action:<br>  The action that AWS WAF should take on a web request when it matches the rule's statement.<br>name:<br>  A friendly name of the rule.<br>priority:<br>  If you define more than one Rule in a WebACL,<br>  AWS WAF evaluates each request against the rules in order based on the value of priority.<br>  AWS WAF processes rules with lower priority first.<br><br>statement:<br>  field\_to\_match:<br>    The part of a web request that you want AWS WAF to inspect.<br>    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#field-to-match<br>  text\_transformation:<br>    Text transformations eliminate some of the unusual formatting that attackers use in web requests in an effort to bypass detection.<br>    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#text-transformation<br><br>visibility\_config:<br>  Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>  cloudwatch\_metrics\_enabled:<br>    Whether the associated resource sends metrics to CloudWatch.<br>  metric\_name:<br>    A friendly name of the CloudWatch metric.<br>  sampled\_requests\_enabled:<br>    Whether AWS WAF should store a sampling of the web requests that match the rules. | `list(any)` | `null` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | Specifies that AWS WAF should allow requests by default. Possible values: `allow`, `block`. | `string` | `"block"` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | A friendly description of the WebACL. | `string` | `"Managed by Terraform"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_geo_match_statement_rules"></a> [geo\_match\_statement\_rules](#input\_geo\_match\_statement\_rules) | A rule statement used to identify web requests based on country of origin.<br><br>action:<br>  The action that AWS WAF should take on a web request when it matches the rule's statement.<br>name:<br>  A friendly name of the rule.<br>priority:<br>  If you define more than one Rule in a WebACL,<br>  AWS WAF evaluates each request against the rules in order based on the value of priority.<br>  AWS WAF processes rules with lower priority first.<br><br>statement:<br>  country\_codes:<br>    A list of two-character country codes.<br>  forwarded\_ip\_config:<br>    fallback\_behavior:<br>      The match status to assign to the web request if the request doesn't have a valid IP address in the specified position.<br>      Possible values: `MATCH`, `NO_MATCH`<br>    header\_name:<br>      The name of the HTTP header to use for the IP address.<br><br>visibility\_config:<br>  Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>  cloudwatch\_metrics\_enabled:<br>    Whether the associated resource sends metrics to CloudWatch.<br>  metric\_name:<br>    A friendly name of the CloudWatch metric.<br>  sampled\_requests\_enabled:<br>    Whether AWS WAF should store a sampling of the web requests that match the rules. | `list(any)` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_import_profile_name"></a> [import\_profile\_name](#input\_import\_profile\_name) | AWS Profile name to use when importing a resource | `string` | `null` | no |
| <a name="input_ip_set_reference_statement_rules"></a> [ip\_set\_reference\_statement\_rules](#input\_ip\_set\_reference\_statement\_rules) | A rule statement used to detect web requests coming from particular IP addresses or address ranges.<br><br>action:<br>  The action that AWS WAF should take on a web request when it matches the rule's statement.<br>name:<br>  A friendly name of the rule.<br>priority:<br>  If you define more than one Rule in a WebACL,<br>  AWS WAF evaluates each request against the rules in order based on the value of priority.<br>  AWS WAF processes rules with lower priority first.<br><br>statement:<br>  arn:<br>    The ARN of the IP Set that this statement references.<br>  ip\_set\_forwarded\_ip\_config:<br>    fallback\_behavior:<br>      The match status to assign to the web request if the request doesn't have a valid IP address in the specified position.<br>      Possible values: `MATCH`, `NO_MATCH`<br>    header\_name:<br>      The name of the HTTP header to use for the IP address.<br>    position:<br>      The position in the header to search for the IP address.<br>      Possible values include: `FIRST`, `LAST`, or `ANY`.<br><br>visibility\_config:<br>  Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>  cloudwatch\_metrics\_enabled:<br>    Whether the associated resource sends metrics to CloudWatch.<br>  metric\_name:<br>    A friendly name of the CloudWatch metric.<br>  sampled\_requests\_enabled:<br>    Whether AWS WAF should store a sampling of the web requests that match the rules. | `list(any)` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_log_destination_configs"></a> [log\_destination\_configs](#input\_log\_destination\_configs) | The Amazon Kinesis Data Firehose ARNs. | `list(string)` | `[]` | no |
| <a name="input_managed_rule_group_statement_rules"></a> [managed\_rule\_group\_statement\_rules](#input\_managed\_rule\_group\_statement\_rules) | A rule statement used to run the rules that are defined in a managed rule group.<br><br>name:<br>  A friendly name of the rule.<br>priority:<br>  If you define more than one Rule in a WebACL,<br>  AWS WAF evaluates each request against the rules in order based on the value of priority.<br>  AWS WAF processes rules with lower priority first.<br><br>override\_action:<br>  The override action to apply to the rules in a rule group.<br>  Possible values: `count`, `none`<br><br>statement:<br>  name:<br>    The name of the managed rule group.<br>  vendor\_name:<br>    The name of the managed rule group vendor.<br>  excluded\_rule:<br>    The list of names of the rules to exclude.<br><br>visibility\_config:<br>  Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>  cloudwatch\_metrics\_enabled:<br>    Whether the associated resource sends metrics to CloudWatch.<br>  metric\_name:<br>    A friendly name of the CloudWatch metric.<br>  sampled\_requests\_enabled:<br>    Whether AWS WAF should store a sampling of the web requests that match the rules. | `list(any)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_rate_based_statement_rules"></a> [rate\_based\_statement\_rules](#input\_rate\_based\_statement\_rules) | A rate-based rule tracks the rate of requests for each originating IP address,<br>and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span.<br><br>action:<br>  The action that AWS WAF should take on a web request when it matches the rule's statement.<br>name:<br>  A friendly name of the rule.<br>priority:<br>  If you define more than one Rule in a WebACL,<br>  AWS WAF evaluates each request against the rules in order based on the value of priority.<br>  AWS WAF processes rules with lower priority first.<br><br>statement:<br>  aggregate\_key\_type:<br>     Setting that indicates how to aggregate the request counts.<br>     Possible values include: `FORWARDED_IP` or `IP`<br>  limit:<br>    The limit on requests per 5-minute period for a single originating IP address.<br>  forwarded\_ip\_config:<br>    fallback\_behavior:<br>      The match status to assign to the web request if the request doesn't have a valid IP address in the specified position.<br>      Possible values: `MATCH`, `NO_MATCH`<br>    header\_name:<br>      The name of the HTTP header to use for the IP address.<br><br>visibility\_config:<br>  Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>  cloudwatch\_metrics\_enabled:<br>    Whether the associated resource sends metrics to CloudWatch.<br>  metric\_name:<br>    A friendly name of the CloudWatch metric.<br>  sampled\_requests\_enabled:<br>    Whether AWS WAF should store a sampling of the web requests that match the rules. | `list(any)` | `null` | no |
| <a name="input_redacted_fields"></a> [redacted\_fields](#input\_redacted\_fields) | The parts of the request that you want to keep out of the logs.<br><br>method\_enabled:<br>  Whether to enable redaction of the HTTP method.<br>  The method indicates the type of operation that the request is asking the origin to perform.<br>uri\_path\_enabled:<br>  Whether to enable redaction of the URI path.<br>  This is the part of a web request that identifies a resource.<br>query\_string\_enabled:<br>  Whether to enable redaction of the query string.<br>  This is the part of a URL that appears after a `?` character, if any.<br>single\_header:<br>  The list of names of the query headers to redact. | <pre>object({<br>    method_enabled       = bool,<br>    uri_path_enabled     = bool,<br>    query_string_enabled = bool,<br>    single_header        = list(string)<br>  })</pre> | `null` | no |
| <a name="input_regex_pattern_set_reference_statement_rules"></a> [regex\_pattern\_set\_reference\_statement\_rules](#input\_regex\_pattern\_set\_reference\_statement\_rules) | A rule statement used to search web request components for matches with regular expressions.<br><br>action:<br>  The action that AWS WAF should take on a web request when it matches the rule's statement.<br>name:<br>  A friendly name of the rule.<br>priority:<br>  If you define more than one Rule in a WebACL,<br>  AWS WAF evaluates each request against the rules in order based on the value of priority.<br>  AWS WAF processes rules with lower priority first.<br><br>statement:<br>  arn:<br>     The Amazon Resource Name (ARN) of the Regex Pattern Set that this statement references.<br>  field\_to\_match:<br>    The part of a web request that you want AWS WAF to inspect.<br>    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#field-to-match<br>  text\_transformation:<br>    Text transformations eliminate some of the unusual formatting that attackers use in web requests in an effort to bypass detection.<br>    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#text-transformation<br><br>visibility\_config:<br>  Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>  cloudwatch\_metrics\_enabled:<br>    Whether the associated resource sends metrics to CloudWatch.<br>  metric\_name:<br>    A friendly name of the CloudWatch metric.<br>  sampled\_requests\_enabled:<br>    Whether AWS WAF should store a sampling of the web requests that match the rules. | `list(any)` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_rule_group_reference_statement_rules"></a> [rule\_group\_reference\_statement\_rules](#input\_rule\_group\_reference\_statement\_rules) | A rule statement used to run the rules that are defined in an WAFv2 Rule Group.<br><br>action:<br>  The action that AWS WAF should take on a web request when it matches the rule's statement.<br>name:<br>  A friendly name of the rule.<br>priority:<br>  If you define more than one Rule in a WebACL,<br>  AWS WAF evaluates each request against the rules in order based on the value of priority.<br>  AWS WAF processes rules with lower priority first.<br><br>override\_action:<br>  The override action to apply to the rules in a rule group.<br>  Possible values: `count`, `none`<br><br>statement:<br>  arn:<br>    The ARN of the `aws_wafv2_rule_group` resource.<br>  excluded\_rule:<br>    The list of names of the rules to exclude.<br><br>visibility\_config:<br>  Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>  cloudwatch\_metrics\_enabled:<br>    Whether the associated resource sends metrics to CloudWatch.<br>  metric\_name:<br>    A friendly name of the CloudWatch metric.<br>  sampled\_requests\_enabled:<br>    Whether AWS WAF should store a sampling of the web requests that match the rules. | `list(any)` | `null` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | Specifies whether this is for an AWS CloudFront distribution or for a regional application.<br>Possible values are `CLOUDFRONT` or `REGIONAL`.<br>To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider. | `string` | `"REGIONAL"` | no |
| <a name="input_size_constraint_statement_rules"></a> [size\_constraint\_statement\_rules](#input\_size\_constraint\_statement\_rules) | A rule statement that uses a comparison operator to compare a number of bytes against the size of a request component.<br><br>action:<br>  The action that AWS WAF should take on a web request when it matches the rule's statement.<br>name:<br>  A friendly name of the rule.<br>priority:<br>  If you define more than one Rule in a WebACL,<br>  AWS WAF evaluates each request against the rules in order based on the value of priority.<br>  AWS WAF processes rules with lower priority first.<br><br>statement:<br>  comparison\_operator:<br>     The operator to use to compare the request part to the size setting.<br>     Possible values: `EQ`, `NE`, `LE`, `LT`, `GE`, or `GT`.<br>  size:<br>    The size, in bytes, to compare to the request part, after any transformations.<br>    Valid values are integers between `0` and `21474836480`, inclusive.<br>  field\_to\_match:<br>    The part of a web request that you want AWS WAF to inspect.<br>    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#field-to-match<br>  text\_transformation:<br>    Text transformations eliminate some of the unusual formatting that attackers use in web requests in an effort to bypass detection.<br>    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#text-transformation<br><br>visibility\_config:<br>  Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>  cloudwatch\_metrics\_enabled:<br>    Whether the associated resource sends metrics to CloudWatch.<br>  metric\_name:<br>    A friendly name of the CloudWatch metric.<br>  sampled\_requests\_enabled:<br>    Whether AWS WAF should store a sampling of the web requests that match the rules. | `list(any)` | `null` | no |
| <a name="input_sqli_match_statement_rules"></a> [sqli\_match\_statement\_rules](#input\_sqli\_match\_statement\_rules) | An SQL injection match condition identifies the part of web requests,<br>such as the URI or the query string, that you want AWS WAF to inspect.<br><br>action:<br>  The action that AWS WAF should take on a web request when it matches the rule's statement.<br>name:<br>  A friendly name of the rule.<br>priority:<br>  If you define more than one Rule in a WebACL,<br>  AWS WAF evaluates each request against the rules in order based on the value of priority.<br>  AWS WAF processes rules with lower priority first.<br><br>statement:<br>  field\_to\_match:<br>    The part of a web request that you want AWS WAF to inspect.<br>    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#field-to-match<br>  text\_transformation:<br>    Text transformations eliminate some of the unusual formatting that attackers use in web requests in an effort to bypass detection.<br>    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#text-transformation<br><br>visibility\_config:<br>  Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>  cloudwatch\_metrics\_enabled:<br>    Whether the associated resource sends metrics to CloudWatch.<br>  metric\_name:<br>    A friendly name of the CloudWatch metric.<br>  sampled\_requests\_enabled:<br>    Whether AWS WAF should store a sampling of the web requests that match the rules. | `list(any)` | `null` | no |
| <a name="input_ssm_path_prefix"></a> [ssm\_path\_prefix](#input\_ssm\_path\_prefix) | SSM path prefix (with leading but not trailing slash) under which to store all WAF info | `string` | `"/waf"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_visibility_config"></a> [visibility\_config](#input\_visibility\_config) | Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>cloudwatch\_metrics\_enabled:<br>  Whether the associated resource sends metrics to CloudWatch.<br>metric\_name:<br>  A friendly name of the CloudWatch metric.<br>sampled\_requests\_enabled:<br>  Whether AWS WAF should store a sampling of the web requests that match the rules. | `map(string)` | `{}` | no |
| <a name="input_xss_match_statement_rules"></a> [xss\_match\_statement\_rules](#input\_xss\_match\_statement\_rules) | A rule statement that defines a cross-site scripting (XSS) match search for AWS WAF to apply to web requests.<br><br>action:<br>  The action that AWS WAF should take on a web request when it matches the rule's statement.<br>name:<br>  A friendly name of the rule.<br>priority:<br>  If you define more than one Rule in a WebACL,<br>  AWS WAF evaluates each request against the rules in order based on the value of priority.<br>  AWS WAF processes rules with lower priority first.<br><br>xss\_match\_statement:<br>  field\_to\_match:<br>    The part of a web request that you want AWS WAF to inspect.<br>    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#field-to-match<br>  text\_transformation:<br>    Text transformations eliminate some of the unusual formatting that attackers use in web requests in an effort to bypass detection.<br>    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#text-transformation<br><br>visibility\_config:<br>  Defines and enables Amazon CloudWatch metrics and web request sample collection.<br><br>  cloudwatch\_metrics\_enabled:<br>    Whether the associated resource sends metrics to CloudWatch.<br>  metric\_name:<br>    A friendly name of the CloudWatch metric.<br>  sampled\_requests\_enabled:<br>    Whether AWS WAF should store a sampling of the web requests that match the rules. | `list(any)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acl"></a> [acl](#output\_acl) | Information about the created WAF ACL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## References
* [cloudposse/terraform-aws-components](https://github.com/cloudposse/terraform-aws-components/tree/master/modules/ecr) - Cloud Posse's upstream component


[<img src="https://cloudposse.com/logo-300x69.svg" height="32" align="right"/>](https://cpco.io/component)