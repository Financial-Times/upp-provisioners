class neo4jha::jumpbox {

    Exec {
    path      => '/usr/bin:/bin:/usr/sbin:/sbin',
    logoutput => true,
  }

  class { 'neo4jha::jumpbox::yum': }
  ->
  class { 'neo4jha::jumpbox::install': notify => Service['collectd'] }
  ->
  class { 'neo4jha::collectd': }

  cron { 'authorized_keys-service':
    command => "/usr/bin/curl -s https://raw.githubusercontent.com/Financial-Times/upp-provisioners/master/upp-neo4j-provisioner/sh/authorized_keys.service.sh | /bin/bash",
    user    => 'root',
    minute  => '*/5',
  }

  file { '/etc/logrotate.d/jumpbox':
    content => '/var/log/jumpbox* {\nrotate 5\nweekly }'
  }
  file { '/etc/sudoers.d': ensure  => 'directory' }
  ->
  file { '/etc/sudoers.d/jumpbox':
    ensure  => 'file',
    content => '%sudoers ALL=(ALL) NOPASSWD:ALL
    '
  }
}
