require 'yaml'
require 'sequel'

CONFIG = YAML::load_file("config.yml")
DB = Sequel.connect ENV['DATABASE_URL'] || CONFIG['database']
DISCARD_OLDER_THAN = Time.now - (60 * 60 * 24 * CONFIG['max_days_of_updates'])

DB[:updates].filter{date < DISCARD_OLDER_THAN}.delete
DB[:tweets].filter{created_at < DISCARD_OLDER_THAN}.delete
