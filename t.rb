#!/usr/bin/ruby

require "shellwords"
require "optparse"

def which(executable)
  system("which", executable, out: "/dev/null", err: "/dev/null")
end

name = nil
debug = false

OptionParser.new do |o|
  o.on("-n NAME", "--name", "TMUX window name"){|v| name = v }
  o.on("--debug", "Show debug information"){ debug = true }
  o.banner = "Usage: #{$0} [options] [command]"
  o.order!(ARGV)
end

# If no arguments, exec tmux new-window
unless executable = ARGV.first
  exec("tmux", "new-window")
end

# Check whether command exists
name ||= executable
unless which(executable)
  STDERR.puts "No such file or direcotry: #{executable}"
  exit 1
end

command = ARGV
# Use `direnv exec` if exists direnv and .envrc
if which("direnv") && File.exist?(".envrc")
  command = ["direnv", "exec", "."] + command
end

# Use `reattach-to-user-namespace` if exists
if which("reattach-to-user-namespace")
  command = ["reattach-to-user-namespace"] + command
end

# Convert environ to inline
# (because tmux new-window reset environments)
env = ENV.reject{|k, v| k == "_"}.map{|kv| kv.map(&:shellescape).join("=") }
command_with_env = env.join(" ") + " " + command.shelljoin
puts command_with_env if debug

exec("tmux", "new-window", "-n", name, command_with_env)
