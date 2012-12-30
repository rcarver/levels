# Levels

[![Build Status](https://secure.travis-ci.org/rcarver/levels.png)](http://travis-ci.org/rcarver/levels)

Levels is a tool for reading and writing configuration data. A level is
a set of key/value pairs that represent your data. Multiple levels are
merged in a predictable, useful way to form your configuration.

  > **KRAMER:** *I'm completely changing the configuration of the apartment. You're not gonna believe it when you see it. A whole new lifestyle.*

  > **JERRY:** *What are you doing?*

  > **KRAMER:** *Levels.*

## Creating a level

Each level is made up of one or more groups. Each group is a set of
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

Now consider having a common "base" configuration, with slight
differences in development and production. Our base configuration
defines the possible keys, with default values.

A "production" level could override the relevant values like this.

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

The system's environment may be used as a level. To alter any value at
runtime, follow a convention to set the appropriate environment
variable.

```bash
TASK_QUEUE_WORKERS="10"
```

### Writing a configuration

Levels may be written in several formats.

  * **RUBY** is the most common and powerful for hand written configs.
  * **JSON** is convenient for machine generated configs.
  * **YAML** is good for both hand written and machine generated configs.
  * **Environment Variables** are useful for local or runtime
    configuration. This syntax may not be used for the "base" level.

#### Data Types

Levels has a limited understanding of data types by design. The guiding
principles are:

  * It must be possible to represent any value in an environment
    variable.
  * Use only types that are native in JSON.

Therefore, Levels only supports the following types:

  * **string** (Ruby `String`)
  * **integer** (Ruby `Fixnum`)
  * **float** (Ruby `Float`)
  * **boolean** (Ruby `TrueClass` or `FalseClass`)
  * **array** (Ruby `Array`) of values, which are also typed.
  * **null** (Ruby `NilClass`)

Notice that JSON's Object is not supported. This is because groups are
objects, so key/values pairs are already available. As well, it's
difficult to represent key/value pairs in an environment variable.

Fortunately, these simple types are perfectly adequate for the purposes
of system configuration.

#### Ruby Syntax

The Ruby DSL is a clean, simple format. It aims to be readable, writable and
editable. It looks like this:

```ruby
group :server
  set hostname: "example.com"

group :task_queue
  set workers: 5
  set queues: ["high", "low"]
```

The Ruby syntax supports **computed values**.

```ruby
group :task_queue
  set queues: -> { [server.hostname, "high", "low"] }
```

##### Extending the Ruby Runtime

To extend the runtime environment, add methods to `Levels::Runtime`.
Those methods can return a value directly, or return a Proc for
lazy evaluation.

```ruby
module Levels::Runtime
  # This helper decrypts a value using the merged value of
  # `secret_keys.sha_key`.
  def encrypted(encrypted_value)
    -> { SHA.decrypt(encrypted_value, secret_keys.sha_key) }
  end
end
```

##### Builtin runtime extensions

These functions are provided by the default Levels Runtime.

  * `file(path)` reads the value from a file. The file path is
    interpreted as relative to the Ruby file unless it begins with '/'.
    File storage can be useful when configuring large strings such as
    SSL keys.

#### JSON Syntax

JSON syntax is straightforward. Because the datatypes supported by
Levels are the same as supported by JSON, there's nothing else you need
to know.

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

#### YAML Syntax

YAML syntax is also exactly as you would expect.

```yaml
---
server:
  hostname: example.com
task_queue:
  workers: 5
  queues:
  - high
  - low
```

#### Environment Variables syntax

The environment variables syntax has rules for defining keys and values.

The format of each key is `[PREFIX]<GROUP>_<KEY>`.

  * `PREFIX` is an optional prefix for all keys.
  * `GROUP` is the name of the group in all caps.
  * `KEY` is the name of the key in all caps.
  * `GROUP` and `KEY` are separated by an underscore (`_`).

The example looks like this (without a prefix).

```sh
SERVER_HOSTNAME="example.com"
TASK_QUEUE_WORKERS="5"
TASK_QUEUE_QUEUES="high:low"
```

##### Typecasting

You'll notice that `TASK_QUEUE_WORKERS` should be an integer, and
`TASK_QUEUE_QUEUES` should be an array. Levels will typecast each value
based on the key's type in the "base" level. Or, you may define each
value's type explicitly.

To set the type of a value, set `<GROUP>_<KEY>_TYPE` to one of the
following values:

  * `string` - The value is taken as is.
  * `integer` - The value is converted to an integer via Ruby's `to_i`.
  * `float` - The value is converted to a float via Ruby's `to_f`.
  * `boolean` - The value is `true` if it's "true" or "1", else `false`.
  * `array` - The value is split using colon (`:`) or
    `<GROUP>_<KEY>_DELIMITER`. The values of the resulting array may be
    typecast using `<GROUP>_<KEY>_TYPE_TYPE`.

Any value may be set to Ruby's `nil` (`NULL`) by setting it to an empty
string.

Some examples:

```sh
SAMPLE_MY_NULL=""

SAMPLE_MY_INT="123"
SAMPLE_MY_INT_TYPE="integer"

SAMPLE_MY_BOOL="true"
SAMPLE_MY_BOOL_TYPE="boolean"

SAMPLE_MY_STRING_ARRAY="a:b:c"
SAMPLE_MY_STRING_ARRAY_TYPE="array"

SAMPLE_MY_INT_ARRAY="1:2:3"
SAMPLE_MY_INT_ARRAY_TYPE="array"
SAMPLE_MY_INT_ARRAY_TYPE_TYPE="integer"

SAMPLE_MY_CSV_ARRAY="one,two,three"
SAMPLE_MY_CSV_ARRAY_TYPE="array"
SAMPLE_MY_CSV_ARRAY_DELIMITER=","
```

## Using a Configuration

Once a level has been written, Levels can read and merge it. Once merged
into a Configuration, you can use it at runtime in a Ruby process, or
output it as JSON, YAML or environment variables.

In any case, any number of levels, including the system environment, may
be merged. The system environment is typically merged last, but it's not
required.

**From the command line**, Levels can generate JSON, YAML or environment
variables. The generated configuration is written to STDOUT. Both JSON
and Environment Variables look exactly like the input formats above.

```sh
levels \
  --output json \
  --level "Base" \
  --level "Prod" \
  --system \
  base.rb \
  prod.json
```

**Within a Ruby program**, a `Levels::Configuration` is an object. You
can build one with `Levels.merge`.

```ruby
# Merge multiple input levels from various sources - file, API and
# environment variables.
config = Levels.merge do |levels|
  levels.add "Base", HTTP.get("http://server/config.json")
  levels.add "Prod", "prod.json"
  levels.add_system
end
```

The resulting `config` object works like this.

```ruby
# Dot syntax.
config.server.hostname        # => "example.com"
config.task_queue.workers     # => 5
config.task_queue.queues      # => ["high", "low"]

# Hash syntax.
config[:server][:hostname]    # => "example.com"
config[:task_queue][:workers] # => 5
config[:task_queue][:queues]  # => ["high", "low"]
```

An attempt to read an unknown group or key will throw an exception.

```ruby
config.some_group        # raises Levels::UnknownGroup
config.server.some_value # raises Levels::UnknownKey
```

You can find out if a group or key exists.

```ruby
config.defined?(:other)           # => false
config.defined?(:server)          # => true
config.server.defined?(:other)    # => false
config.server.defined?(:hostname) # => true
```

## Author

Ryan Carver / @rcarver

Copyright (c) Ryan Carver 2012. Made available under the MIT license.

