#!/bin/sh
#
# This example shows how to store and read a value from a file.
#
#   * examples/02_base.rb reads a file twice. Once where the file name
#     is known, and once where it is unknown until set via an 
#     environment variable.

examples="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"

# Alter a value via the system environment.
export EXAMPLES_FILE_NAME='02_value'

bundle exec levels \
  --output json \
  --level "Base" \
  --system \
  $examples/02_base.rb


