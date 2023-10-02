# app/workers/backup_worker.rb
class BackupWorker
    include Sidekiq::Worker
  
    def perform
      # Define your database backup logic here using the 'backup' gem.
      # For example, you can create a backup using the Backup gem:
      Backup::Model.new(:my_backup, 'My Backup') do
        database PostgreSQL do |db|
          db.name               = 'lightmfb_requests_dev'
          db.username           = 'mangut'
          db.password           = 'password'
          db.host               = 'localhost'
          db.port               = 3306
          db.additional_options = ['-xc', '--lock-timeout=0']
          db.socket             = '/tmp/pg.sock'
        end
  
        store_with Local do |local|
          local.path = 'C:/Backups'
          local.keep = 7
        end
  
        compress_with Gzip
      end
  
      Backup::Logger.configure do
        logfile.enabled = true
        logfile.log_path = 'C:/Backups/logs'
        logfile.max_bytes = 500_000
      end
  
      Backup::Logger.info 'Starting database backup...'
      Backup::Model.find_by_trigger('my_backup').start
      Backup::Logger.info 'Database backup completed.'
    end
  end
  