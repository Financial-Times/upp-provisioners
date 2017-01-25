class neo4jha::jumpbox {

  cron { 'scheduled-deployment':
    command => "/usr/bin/curl -s https://raw.githubusercontent.com/Financial-Times/up-neo4j-ha-cluster/master/sh/jumpbox.sh | /bin/bash",
    user    => 'root',
    minute  => '*/5',
  }

  file { '/etc/logrotate.d/jumpbox':
    content => '/var/log/jumpbox* {
                rotate 5
                weekly
                }'
  }
}
