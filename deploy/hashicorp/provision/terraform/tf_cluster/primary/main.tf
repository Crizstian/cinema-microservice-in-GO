module "tf_consul" {
  source = "../../consul"

  datacenters = var.consul_datacenters
  
  enable_agent_policy     = true
  enable_anonymous_policy = true
  enable_sensitive_policy = true
  enable_blocking_policy  = true
  enable_server_role      = true

  enable_intentions             = true
  enable_deny_all               = true
  service_to_service_intentions = var.service_to_service_intentions

  enabled_prepared_queries = true
  prepared_queries         = var.prepared_queries

  store_kv = [{
    path  = "cluster/info/status"
    value = "active"
  }]

  consul_central_config   = var.service_defaults_apps
  proxy_defaults          = var.proxy_defaults
  enable_proxy_defaults   = true
  enable_service_splitter = true
  enable_service_resolver = true
  enable_service_defaults = true # currently not working https://github.com/terraform-providers/terraform-provider-consul/issues/191 # works with 1.7
}

module "tf_vault" {
  source = "../../vault"

  enable_app_role                = true
  enable_userpass_engine         = true
  enable_store_approle_in_consul = true
  
  roles                          = concat(var.apps, var.infrastructure, var.dbs)
  consul_datacenter              = var.consul_datacenter
  
  enable_admin_policy            = true
  enable_infrastructure_policy   = true
  enable_app_policy              = true
  policy_apps                    = concat(var.apps, var.dbs)
  
  enable_consul_engine           = false
  enable_kv_engine               = true
  enable_mongo_db_engine         = false
  enable_admin_user              = true
  
  deploy_cinema_microservice_secrets = true
  deploy_mongodb_secrets             = true
}