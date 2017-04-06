class neo4jha::download {

  user { "${::neo4jha::username}":
    ensure      => present,
    managehome  => true,
  }
  ->
  file { "${::neo4jha::parentdir}":
    ensure => directory,
    owner  => "${::neo4jha::username}",
    group  => "${::neo4jha::username}",

  }

  if ("${::neo4jha::profile}" == 'dev') {
    notify { "Using dev profile": }
    exec { 'File copy Neo4j Enterprise':
      user    => "${::neo4jha::username}",
      cwd     => "${::neo4jha::parentdir}",
      unless  => "test -f ${::neo4jha::parentdir}/${::neo4jha::package}",
      command => "cp /mnt/neo/${::neo4jha::package} .",
      require => File["$::neo4jha::parentdir"]
    }
  }
  else {
    exec { 'Download Neo4j Enterprise':
      user    => "${::neo4jha::username}",
      cwd     => "${::neo4jha::parentdir}",
      unless  => "test -f ${::neo4jha::parentdir}/${::neo4jha::package}",
      command => "wget ${::neo4jha::downloadurl} -O ${::neo4jha::package}",
      require => File["$::neo4jha::parentdir"]
    }
  }
}
