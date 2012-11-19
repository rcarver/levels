#!/bin/sh
#
# This example sets up three levels:
#
#   * "Base" from examples/01_base.rb
#   * "Prod" from examples/01_prod.json
#   * "System Environment" with no prefix.
#
# Base defines the possible keys with default vaules, Prod changes a few of
# those values, and System changes one more.
#
# A log of the levels used, and where each value came from is written to
# STDERR. The merged output as JSON is written to STDOUT.

examples="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"

# Alter a value via the system environment.
export TASK_QUEUE_WORKERS='10'

bundle exec levels \
  --output json \
  --level "Base" \
  --level "Prod" \
  --system \
  $examples/01_base.rb \
  $examples/01_prod.json

