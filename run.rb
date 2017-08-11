@websites = {
  website: {
    method: ENV['METHOD'],
    url: ENV['URL'],
    text: ENV['TEXT'],
    params: ENV['PARAMS']
  }
}

require_relative 'HTMLElementPathfinder.rb'
