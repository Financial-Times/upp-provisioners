class neo4jha::jumpbox::graphite {
  package { 'collectd': ensure 'present', }
  ->
  file { '/etc/collectd.d':
    ensure  => 'directory',
    recurse => true,
    source => "puppet:///${module_name}/graphite",
  }
  ~>
  service { 'collectd':
    ensure => 'running',
    enable => true, }

}
