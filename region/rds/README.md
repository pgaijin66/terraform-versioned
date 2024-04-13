# RDS

## FAQ / Common problems

### Encrypting the DB password with sops

You can encrypt your DB password with SOPS and definitely should.

To use SOPS with the RDS module, the SOPS provider needs to be declared in a `terraform-config.tf` file located in the same directory as the module.

Example `terraform-config.tf`:
```hcl
terraform {
  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.6.0"
    }
  }
}
provider "sops" {}
```

You can then instantiate a `sops_file` data resource anywhere, like such:

```hcl
data "sops_file" "secret_file_for_terraform" {
  source_file = "${path.module}/some_file_encrypted_with_sops.yaml"
}
```

Encrypt SOPS files how you usually would with Helm secrets.

A full working example of this can be found [here](https://github.com/CapsuleHealth/terraform-module-swe-example/tree/master/terraform/prod/rds/us-east-1).

### DB password requirements

When generating the password for the DB, ensure that there are no `/`, `"`, or `@` characters in it -- this is a limitation of Postgres.

### `name` parameter

The `name` parameter is for the default database for RDS to create, not the name of the RDS instance. These are subject to the [Postgresql table naming restrictions](https://www.postgresql.org/docs/7.0/syntax525.htm) -- tl;dr must match `^[a-zA-Z_][a-zA-Z0-9_]+`.

All PRs could've been avoided if we (SRE) had adequate docs explaining all these nuances (with examples):

    What TF providers are required for SOPS

    Valid values for the (internal) db name (not the DB identifier) - no dashes

    Valid values for the DB pwd - no "/" etc.

### `auto_minor_version_upgrade` boolean

The `auto_minor_version_upgrade` boolean parameter dictates whether to let [AWS automatically perform minor engine version upgrades](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Upgrading.html#USER_UpgradeDBInstance.Upgrading.AutoMinorVersionUpgrades) at your specified maintenance window.

We recommend you setting this parameter to `auto_minor_version_upgrade = true` (default) as AWS can deprecate older minor engine versions and may not inform you of this deprecation.
Setting this paramater to `true` also reinforces a behavior of constant maintenance and upgrades - minor versions should not contain breaking changes so your application should not be impacted.

**How to manage Terraform versioning drift?**

Previously, the `engine_version` parameter was typically set to explicit versions e.g. `10.5`. If `auto_minor_version_upgrade = true`, then AWS would update the version and your Terraform would not match the upgraded version, causing drift.

As you are reading this document, we are assuming that you are using SRE's modules and because of that, you can mitigate this drift by just setting the major version e.g. `engine_version = 10`. With `auto_minor_version_upgrade = true`, even if AWS upgrades the minor version there will be no drift as Terraform will create an attribute called `engine_version_actual` which will represent the final version of the database.

### Upgrading RDS Major Version

We recommend setting the `engine_version` paramater to only represent the major database version.

If you are upgrading the major version, we recommend that you use the [oncall_admin](https://capsulerx.atlassian.net/wiki/spaces/devops/pages/3007676421/AWS+Access#oncall_admin) role to perform the upgrade **manually** during a maintenance period. A database change such as this is simple in theory, just time-consuming.

This is what happens during an upgrade:
* AWS performs a full snapshot of your database (there is no downtime for this step) so that there is a backup **pre-upgrade**. The time to complete the snapshot is dependent on how much data is present (expect this to take towards an hour)
* If `Multi-AZ = true`, AWS will upgrade the backup instance first (there is no downtime for this step). This could take up to 30 min to complete.
* Existing DB connections will be flushed from the primary instance to the newly upgraded instance. This will cause intermittent downtime for a couple minutes.
* The primary instance will now be upgraded and connections will be flushed back to the primary instance. The connection flushing procedure will cause another intermittent downtime for a couple minutes.
* There will be another full snapshot of your database (there is no downtime for this step) so that there is a backup **post-upgrade**.

Once the upgrade has completed, follow-up with a Terraform PR to the database that will no-op the upgrade.
