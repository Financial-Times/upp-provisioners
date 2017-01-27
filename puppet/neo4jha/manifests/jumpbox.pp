class neo4jha::jumpbox {

  cron { 'authorized_keys-service':
    command => "/usr/bin/curl -s https://raw.githubusercontent.com/Financial-Times/up-neo4j-ha-cluster/master/sh/authorized_keys.service.sh | /bin/bash",
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
