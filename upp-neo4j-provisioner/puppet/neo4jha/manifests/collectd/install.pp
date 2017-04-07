class neo4jha::collectd::install {

  package { 'collectd':
   ensure         => 'present',
   allow_virtual  => false,
   }

  file { '/etc/collectd.d':
    ensure  => 'directory',
    recurse => true,
    source  => "puppet:///modules/${module_name}/collectd/collectd-conf",
  }

}
