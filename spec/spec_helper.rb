$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'capistrano'
require 'singleton'
require 'sshkit'
require 'capistrano/locally'
