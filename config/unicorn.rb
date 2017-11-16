root = "/home/app_runner/vagnar/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.vagnar.sock"
worker_processes 4
timeout 10
preload_app false
