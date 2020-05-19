if NapoleonApp.development?
  threads 0, 1
  workers 0
  worker_timeout 60*60*24
end
