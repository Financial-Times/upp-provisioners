class neo4jha::jumpbox::install {
  package { 'requests':
    ensure    => '2.13.0',
    provider  => 'pip'
  }

}
