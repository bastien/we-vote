namespace :we_vote do  
  desc "Sync extra files from blogify plugin"  
  task :sync do  
    system "rsync -ruv vendor/plugins/we-vote/db/migrate db"  
  end  
end