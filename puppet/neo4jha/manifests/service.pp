class neo4jha::service {

  service {'neo4j':
    enable      => true,
    ensure      => running,
    hasrestart  => true,
    subscribe   => File["${::neo4jha::neo4j_home}/conf/neo4j.conf"]
  }

}
