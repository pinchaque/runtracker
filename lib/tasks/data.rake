# Tasks related to asynchronous data processing
namespace :data do
  desc "Recalculate all summary tables"
  task :sum => :environment do
    SumActivity.recalculate_all
  end
end
