require 'scheduler_daemon/rails/railtie' if defined?(Rails) && Rails.version =~ /^3\./
require 'scheduler_daemon/base'