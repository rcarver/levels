group :webserver
  set hostname: "localhost"

group :task_queue
  set workers: 1
  set queues: -> { ["high", "low", webserver.hostname] }
