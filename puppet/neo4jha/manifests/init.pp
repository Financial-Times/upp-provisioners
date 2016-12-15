# == Class: neo4jha
#
# Deploy Neo4j high-availability cluster
#
#
# === Authors
#
# Jussi Heinonen <jussi.heinonen@ft.com>
#

class neo4jha ($profile = 'dev') {
  $parentdir = '/opt/neo4j'
  $package      = "neo4j-enterprise-3.1.0-unix.tar.gz"
  $neo4j_home   = "${parentdir}/neo4j-enterprise-3.1.0"
  $downloadurl  = "https://neo4j.com/artifact.php?name=${package}"
  $username     = 'neo4j'

  Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }

  class { 'neo4jha::download': }
  ->
  class { 'neo4jha::install': }
  ->
  class { 'neo4jha::configure': }
  ->
  class { 'neo4jha::service': }
}
