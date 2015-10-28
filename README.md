# Fluentd

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Install, configure, and manage Fluentd data collector.

## Module Description

* Installs `td-agent` package
* Generates configuration file `td-agent.conf`
* Generates custom configuration files and saves them to `config.d/`
* Manages `td-agent` service
* Installs Fluentd gem plugins

## Usage

### Routing events to Elasticsearch

```puppet
include fluentd

fluentd::plugin { 'fluent-plugin-elasticsearch': }

fluentd::config { 'elasticsearch.conf':
  config => {
    'source' => {
      'type' => 'unix',
      'path' => '/tmp/fluent.sock',
    },
    'match'  => {
      'tag_pattern'     => '**',
      'type'            => 'elasticsearch',
      'index_name'      => 'foo',
      'type_name'       => 'bar',
      'logstash_format' => true,
    }
  }
}
```

### Forwarding events to Fluentd aggregator

```puppet
include fluentd

fluentd::config { 'forwarding.conf':
  config => {
    'source' => {
      'type' => unix,
      'path' => '/tmp/td-agent/td-agent.sock',
    },
    'match'  => {
      'tag_pattern' => '**',
      'type'        => forward,
      'server'      => [
        { 'host' => 'example1.com', 'port' => 24224 },
        { 'host' => 'example2.com', 'port' => 24224 },
      ]
    }
  }
}
```

## Reference

### Classes

#### Public Classes

* `fluentd`: Main class, includes all other classes.

#### Private Classes

* `fluentd::install`: Handles the packages.
* `fluentd::service`: Handles the service.

### Parameters

The following parameters are available in the `fluentd` class:

#### `repo_install`

Default value: true

#### `repo_name`

Default value: 'treasuredata'

#### `repo_desc`

Default value: 'TreasureData'

#### `repo_url`

Default value: 'http://packages.treasuredata.com/2/redhat/$releasever/$basearch'

#### `repo_enabled`

Default value: true

#### `repo_gpgcheck`

Default value: true

#### `repo_gpgkey`

Default value: 'https://packages.treasuredata.com/GPG-KEY-td-agent'

#### `repo_gpgkeyid`

Default value: 'C901622B5EC4AF820C38AB861093DB45A12E206F'

#### `package_name`

Default value: 'td-agent'

#### `package_ensure`

Default value: present

#### `service_name`

Default value: 'td-agent'

#### `service_ensure`

Default value: running

#### `service_enable`

Default value: true

#### `service_manage`

Default value: true

#### `config_file`

Default value: '/etc/td-agent/td-agent.conf'

### Public Defines

* `fluentd::config`: Generates custom configuration files.
* `fluentd::plugin`: Installs plugins.

The following parameters are available in the `fluentd::plugin` defined type:

#### `title`

Plugin name

#### `plugin_ensure`

Default value: present

#### `plugin_source`

Default value: 'https://rubygems.org'

The following parameters are available in the `fluentd::config` defined type:

#### `title`

Config filename

#### `config`

Config Hash, please see usage examples.

## Limitations

Tested only on CentOS 7, Ubuntu 14.04, Debian 7.8

## Development

Bug reports and pull requests are welcome!

### TODO:

* Remove `rubygems` package dependency

## License

Copyright 2015 SPB TV AG

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License.

You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.

See the License for the specific language governing permissions and limitations
under the License.
