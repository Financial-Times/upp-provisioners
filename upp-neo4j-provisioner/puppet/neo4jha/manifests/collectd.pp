class neo4jha::collectd {
  class { "${module_name}::collectd::install": notify => Service['collectd'] }

  class { "${module_name}::collectd::plugins":
    namespace => 'com.ft.up.semantic',
    notify => Service['collectd'] }

  class { "${module_name}::collectd::service": }

}
