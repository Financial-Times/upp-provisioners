class neo4jha::collectd::service {
  service { 'collectd':
    ensure  => 'running',
    enable  => true, }
}
