namespace :db do
  desc "Optimize all database tables"
  task optimize_tables: :environment do
    t = Time.new.to_f
    tables = ActiveRecord::Base.connection.tables
    tables.each do |table|
      ActiveRecord::Base.connection.execute("OPTIMIZE TABLE #{table};")
    end
    puts "#{Time.now} Optimized #{tables.size} tables in #{(Time.new.to_f - t)} seconds"
  end

  desc "Drops, creates, migrates and seeds the db"
  task recreate: :environment do
    %w[drop create migrate seed].each do |task|
      Rake::Task["db:#{task}"].invoke
    end
  end
end
