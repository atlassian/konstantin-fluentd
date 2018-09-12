class fluentd::install inherits fluentd {
  if $fluentd::repo_install {
    require fluentd::install_repo
  }

  package { $fluentd::package_name:
    ensure => $fluentd::package_ensure,
  }

  -> if $fluentd::init_manage {
    file { '/etc/init.d/td-agent':
      ensure  => file,
      content => template('fluentd/td-agent.erb'),
    }
      ~> exec { '/usr/bin/systemctl daemon-reload':
      refreshonly => true,
    }
  }

  -> file { $fluentd::config_path:
    ensure  => directory,
    owner   => $fluentd::config_owner,
    group   => $fluentd::config_group,
    mode    => '0750',
    recurse => true,
    force   => true,
    purge   => true,
  }

  -> file { $fluentd::config_file:
    ensure => present,
    source => 'puppet:///modules/fluentd/td-agent.conf',
    owner  => $fluentd::config_owner,
    group  => $fluentd::config_group,
    mode   => '0640',
  }
}
