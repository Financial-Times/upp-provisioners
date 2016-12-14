class neo4jha::configure {

  file { "${::neo4jha::neo4j_home}/conf/neo4j.conf":
    owner   => "${::neo4jha::username}",
    content => template("${module_name}/neo4j.conf.erb");
  }

  file { "/etc/init.d/neo4j":
    mode    => '755',
    content => template("${module_name}/neo4j.sh");
  }

  file { ['/var/log/apps', '/var/log/apps/neo4j']:
    owner    => "${::neo4jha::username}",
    group    => "${::neo4jha::username}",
    ensure  => directory,
  }
  ->
  file { "${::neo4jha::neo4j_home}/logs":
    owner    => "${::neo4jha::username}",
    group    => "${::neo4jha::username}",
    force   => true,
    ensure  => link,
    target  => "/var/log/apps/neo4j",
  }
}
