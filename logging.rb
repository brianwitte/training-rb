require 'logger'

# LOGGER 
#

#log = Logger.new($stderr) # logs to stderr
log = Logger.new('my_logs.log') # logs to file


# CONTROLLING LOG LEVEL
#

# attempt retrieve env var otherwise set as INFO via fetch
# makes log level externally configurable which is almost always preferable
log.level = Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO"))


# log levels in descending order
log.debug "this is debug"
log.info "hello, logging world!"
log.warn "woah, warning"
log.error "this is an error msg"
log.fatal "fatalityyyyy"


# OPTIONAL LOGGING
#

# Dummy User class for Optional Logging example
class User #< ApplicationRecord (let's pretend)
  def initialize
    random_string = ('a'..'z').to_a.shuffle[0,8].join
    @id = random_string
    @name = "User-#{random_string.split(//).last(5).join}"
  end
end

def find_important_user
  # method performs database query (performance overhead)
  user = User.new # pretend this is a User.find_by!
  return user
end

# imagine below is frequently called method that provides
# useful information for debugging
100000.times do
  
  # SLOW without {}
  log.debug { "Important request from #{find_important_user}" }

  # DO NOT DO BELOW (no {}):
  #
  # log.debug "Important request from #{find_important_user}" 
  #
  # constructs string even if debug is suppressed via LOG_LEVEL (like INFO)
  # feature of Logger is if argument is passed as block, the Logger object
  # will lookup LOG_LEVEL and discard block contents if level is suppressed
  # without block it will construct string arg every time and thus execute
  # any methods within it
end

# below is performance benchmark of {} vs without {} in log statement
# benchmark is 11x slower without {}

# me @ linux ~/training-rb (main)
# └─ $ ▶ hyperfine 'ruby logging.rb' 'ruby slow_logging.rb' --warmup 4
# Benchmark 1: ruby logging.rb
#   Time (mean ± σ):     110.2 ms ±  10.7 ms    [User: 92.2 ms, System: 20.6 ms]
#   Range (min … max):    97.8 ms … 136.2 ms    29 runs
#  
# Benchmark 2: ruby slow_logging.rb
#   Time (mean ± σ):      1.281 s ±  0.055 s    [User: 1.266 s, System: 0.017 s]
#   Range (min … max):    1.217 s …  1.367 s    10 runs
#  
# Summary
#   'ruby logging.rb' ran
#    11.63 ± 1.23 times faster than 'ruby slow_logging.rb'
