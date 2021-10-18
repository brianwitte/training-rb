require 'logger'

#log = Logger.new($stderr) # logs to stderr
log = Logger.new('my_logs.log') # logs to file
# attempt retrieve env var otherwise set as INFO via fetch
# makes log level externally configurable
log.level = Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO"))

log.debug "this is debug"
log.info "hello, logging world!"
log.warn "woah, warning"
log.error "this is an error msg"
log.fatal "fatalityyyyy"

