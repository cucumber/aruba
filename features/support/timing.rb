# From https://itshouldbeuseful.wordpress.com/2010/11/10/find-your-slowest-running-cucumber-features/

scenario_times = {}

Around do |scenario, block|
  name = "#{scenario.location.file}:#{scenario.location.line} # #{scenario.name}"

  start = Time.now
  block.call
  end_time = Time.now
  scenario_times[name] = end_time - start
end

at_exit do
  sorted_times = scenario_times.sort { |a, b| b[1] <=> a[1] }
  slowest_times = sorted_times.first(20)
  puts "------------- Top #{slowest_times.size} slowest scenarios -------------"
  slowest_times.each do |key, value|
    puts format("%.2f  %s", value, key)
  end
end
