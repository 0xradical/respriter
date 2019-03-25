Before('@elasticsearch') do
  Course.reset_index!
end

AfterStep('@slow-motion') do
  sleep(7)
end
