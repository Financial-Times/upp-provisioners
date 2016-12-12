class neo4jha::install {

  exec { 'Extract package':
    user    => "${::neo4jha::username}",
    cwd     => "${::neo4jha::parentdir}",
    unless  => "test -d ${::neo4jha::neo4j_home}",
    command => "tar -zxvf ${::neo4jha::parentdir}/${::neo4jha::package}"
  }

  package { 'java-1.8.0-openjdk': ensure => present, allow_virtual => true }
  ->
  # Switch default java to 1.8 if not already done so
  file { '/etc/alternatives/java':
    ensure  => link,
    target  => '/usr/lib/jvm/jre-1.8.0-openjdk/bin/java'
  }


}
