$worker  = 2
$timeout = 30
$app_dir = "/var/www/rails/ura_reputation" #自分のアプリケーション名
$listen  = '/var/www/rails/ura_reputation/tmp/sockets/.unicorn.sock'
$pid     = '/var/www/rails/ura_reputation/tmp/pids/unicorn.pid'
$std_log = '/var/www/rails/ura_reputation/log/unicorn.log'
# set config
worker_processes  $worker
working_directory $app_dir
stderr_path $std_log
stdout_path $std_log
timeout $timeout
listen  $listen
pid $pid
# loading booster
preload_app true
# before starting processes
before_fork do |server, worker|
  defined?(ApplicationRecord) and ApplicationRecord.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      Process.kill "QUIT", File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
# after finishing processes
after_fork do |server, worker|
  defined?(ApplicationRecord) and ApplicationRecord.establish_connection
end
