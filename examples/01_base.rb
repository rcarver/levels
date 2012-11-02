set :webserver,
  hostname: "localhost"

set :task_queue,
  workers: 1,
  queues: -> { ["high", "low", webserver.hostname] }
