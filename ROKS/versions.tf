terraform {
  required_version = ">=1.0.7"
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
    }
  }
  experiments = [module_variable_optional_attrs]
}
