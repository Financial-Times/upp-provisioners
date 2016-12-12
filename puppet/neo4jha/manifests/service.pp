class neo4jha::service {

  service {'neo4j':
    enable      => true,
    ensure      => running,
    hasrestart  => true,
  }

}
