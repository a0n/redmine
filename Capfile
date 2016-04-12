require 'sshkit/sudo'
# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/puma'
require 'capistrano/puma/workers'
# require 'capistrano/puma/jungle'
require 'capistrano/puma/monit'
# require 'capistrano/puma/nginx'

require 'capistrano/rails/assets' # for asset handling add
require 'capistrano/faster_assets'
require 'capistrano/rails/migrations' # for running migrations

require 'capistrano/upload-config'


# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
