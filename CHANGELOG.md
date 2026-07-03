# 0.4.1 (Jul 03, 2026)
* Switched to using `data.ns_workspace.gcp_labels` instead of `tags`.
* Upgraded TF providers.
* Switched to OpenTofu.

# 0.4.0 (Jun 24, 2026)
* Added `var.enable_psc` to support Private Service Connect in addition to Private Service Access.
* Added `var.deletion_protection_enabled` to protect the instance from deletion at both the Terraform and GCP API levels.

# 0.3.1 (Nov 27, 2024)
* Fix upgrade of Google provider.

# 0.3.0 (Nov 27, 2024)
* Move networking setup to network module.
* Upgrade Terraform modules.

# 0.2.1 (Jun 12, 2023)
* Fix reference to service networking connection.

# 0.2.0 (Jun 12, 2023)
* Upgrade mysql db admin.

# 0.1.0 (Jun 12, 2023)
* Fixed creation of two mysql instances in one project. (Fixed unique global IP address)
* Added `mysql-db-admin` to enable administration of databases/users through access module.
