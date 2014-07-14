# == Class: monit
#
# Full description of class monit here.
#
# === Parameters
# $monit_version: monit version to install
# $install_packages: boolean, if the monit class should also install monitored packages
# $monitored_packages: hash, {service_name => {name => x, process_timeout => y, pid_name => z, ensure => present}}, where service_name is the name of the package to install,x is the name of the service associated with the package (optional is package name is the same as the service name)  y is the (optional) process_timeout for monit, z is the pid name/location that monit will monitor and ensure is whether monit should monitor this resource
# === Variables
# $resource_names: an array of packages to install if $install_packages is true
# Monit: custom type that allows monit to monitor
#
# === Examples
#
# class {'monit':
#   monitored_packages => {
#     'httpd' => { process_timeout => 30,pid_name => '/var/run/httpd/httpd.pid', ensure => present },
#     'openssh' => { name =>'sshd' ,process_timeout => 30, pid_name => '/var/run/sshd.pid', ensure => present }
#   }
# }
#
# === Authors
#
# Michael Stein 
#
class monit($monit_version = 'latest',$install_packages = true, $monitored_packages = {}) {
  create_resources("@monit", $monitored_packages)
  $resource_names = get_package_names($monitored_packages) 
  package{'monit':
    ensure => $monit_version,
  }
  if $install_packages == true {
    package{$resource_names:
      ensure => present,
      require => Package['monit'],
      before => File['/etc/monit.d']
    }
  }
  file{'/etc/monit.d':
    ensure => directory,
    require => Package['monit'],
  }->
  file{'/etc/monit.d/monit.conf':
    ensure => present,
    content => (" set httpd port 2812 and\n      use address localhost\n     allow localhost")
  }~>
  service{'monit':
    ensure => 'running',
  }->Monit<| |>
}
