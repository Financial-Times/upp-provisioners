class neo4jha::collectd::plugins ($namespace = 'collectd') {
  file { '/opt/collectd-plugins':
    ensure  => 'directory',
    recurse => remote,
    recurselimit => 10,
    source  => "puppet:///modules/${module_name}/collectd/collectd-plugins/",
  }
  ->
  file { "/opt/collectd-plugins/cloudwatch/config/plugin.conf":
    content => template("${module_name}/collectd/collectd-plugins/cloudwatch/config/plugin.conf.erb");
  }
  ->
  file { "/opt/collectd-plugins/cloudwatch/modules/plugininfo.py":
    content => template("${module_name}/collectd/collectd-plugins/cloudwatch/modules/plugininfo.py.erb");
  }

}
