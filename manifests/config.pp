define fluentd::config($config) {
  include fluentd

  file { "${fluentd::config_path}/${title}":
    ensure  => present,
    content => fluent_config($config),
    require => Class['Fluentd::Install'],
    notify  => Class['Fluentd::Service'],
  }

  if $fluentd::init_manage {
    file { '/etc/init.d/td-agent':
      ensure  => file,
      content => template('fluentd/td-agent.erb'),
    }
      ~> exec { '/usr/bin/systemctl daemon-reload':
      refreshonly => true,
    }
  }
}
