# Config::Env

Env is a tool for managing configuration. It allows for multiple levels
of configuration to be merged in a predictable, useful way.
Configuration data may be stored in a variety of formats. Those values
are normalized and resolved by Env, then prepared for output or use by
an application.

## Creating a configuration

Env configurations are made up of Groups and Levels.

### Groups

An Env configuration is organized into Groups. Each group is a set of
key/value pairs. To describe a very simple web application made up of a
server and a task queue, you could write this (in JSON).

```json
{
  "server": {
    "hostname": "example.com"
  },
  "task_queue": {
    "workers": 5,
    "queues": ["high", "low"]
  }
}
```

### Levels

Extending the example above, you can add additional levels of
configuration. Consider having a common "base" configuration, with
slight differences in development and production. Our base
configuration defines the possible keys, with default values.

```json
{
  "server": {
    "hostname": "localhost"
  },
  "task_queue": {
    "workers": 1,
    "queues": ["high", "low"]
  }
}
```

A production configuration can override the relevant values.

```json
{
  "server": {
    "hostname": "example.com"
  },
  "task_queue": {
    "workers": 5
  }
}
```

The system's environment is another Level. To alter a value at runtime,
follow a convention to set the appropriate environment variable.

```bash
TASK_QUEUE_WORKERS="10"
```

Env will find the variable `TASK_QUEUE_WORKERS` and automatically
typecast the value based on the existing configuration, or
[typecasting](#typecasting) rules may be used.

### Ruby Syntax

JSON and ENV variables are useful, but the most flexible format is Ruby.
Env provides a simple DSL for writing groups.

```ruby
configure :server,
  hostname: "example.com"

configure :task_queue,
  workers: 5,
  queues: ["high", "low"]
```

Ruby has the advantage of computed values. A contrived example:

```ruby
configure :task_queue,
  queues: -> { [server.hostname, "high", "low"] }
```

Computed values can be used to implement things like encrypted secrets.

```ruby
configure :secrets,
  key: "..."

configure :aws,
  secret_key: -> { Secrets.decrypt("...", secrets.key) }
```

The DSL can be extended to make this cleaner.

```ruby
# Extend Config::Env::Runtime with new functions.
module Config::Env::Runtime
  def secret(value)
    -> { Secrets.decrypt(value, secrets.key) }
  end
end

configure :aws,
  secret_key: secret("...")
```

## Reading a configuration

Once a configuration has been defined, Env can read it. Again, there are
several options for reading. Consider this simple configuration for the
following examples.

```ruby
configure :server,
  hostname: "example.com"

configure :task_queue,
  workers: 5,
  queues: ["high", "low"]
```

### Environment Variables

The simplest way to read a configuration is to write it to environment
variables. The configuration above results in this shell script. Note
that all values have been converted to string, and typecast information
is included. See [typecasting](#typecasting).

```sh
export SERVER_HOSTNAME="example.com"
export SERVER_HOSTNAME_TYPE="string"

export TASK_QUEUE_WORKERS="5"
export TASK_QUEUE_WORKERS_TYPE="int"

export TASK_QUEUE_QUEUES="high:low"
export TASK_QUEUE_QUEUES_TYPE="array"
export TASK_QUEUE_QUEUES_DELIMETER=":"
```

### Ruby

Within a Ruby runtime, Env provides a simple syntax for reading.

```ruby
# Dot syntax.
env.server.hostname        # => "example.com"
env.task_queue.workers     # => 5
env.task_queue.queues      # => ["high", "low"]

# Hash syntax.
env[:server][:hostname]    # => "example.com"
env[:task_queue][:workers] # => 5
env[:task_queue][:queues]  # => ["high", "low"]
```

An attempt to read an unknown group or key will throw an exception.

```ruby
env.some_group        # raises Config::Env::UnknownGroup
env.server.some_value # raises Config::Env::UnknownKey
```

Env can find out if a group or key exists.

```ruby
env.defined?(:other)           # => false
env.defined?(:server)          # => true
env.server.defined?(:other)    # => false
env.server.defined?(:hostname) # => true
```

## Typecasting

In several examples, we've seen environment variables contain non-string
data. The following typecasting rules are used when using the system
environment as Level in a configuration, as well as when exporting a
configuration to environment variables.

```sh
# A configuration value has this form.
[PREFIX]<GROUP>_<KEY>

# The type of that value can be set here.
[PREFIX]<GROUP>_<KEY>_TYPE

# The type may require more information for conversion, in which case
# additional keys may be used.
[PREFIX]<GROUP>_<KEY>_<OTHER>
```

Env supports the following types:

  * `string` - The value is taken as is.
  * `int` - The value is converted to an integer via Ruby's `to_i`.
  * `array` - The value is split using `_DELIMETER` or colon (`:`). The
    values of the resulting array may be typecast using `_TYPE_TYPE`.

## Usage

From the command line Env can generate environment variables or JSON.

```sh
config-env \
  --format json \
  --level "Base" \
  --level "Prod" \
  --system \
  base.rb \
  prod.json
```

Within a Ruby program, Env is an object.

```ruby
# Specify the inputs.
setup = Config::Env.setup
setup.level "Base", "base.rb"
setup.level "Prod", "prod.json"
setup.system
# Get a merged configuration.
my_env = setup.merge
```

In either case, any number of levels, including the system environment,
may be merged. The system environment is typically merged last, but it's
not required.

## Author

Ryan Carver / @rcarver

Copyright (c) Ryan Carver 2012. Made available under the MIT license.

