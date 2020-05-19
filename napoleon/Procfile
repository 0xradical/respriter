web:     bundle exec rackup -s puma --port $PORT --host 0.0.0.0
worker:  bundle exec que -w 1 ./app.rb
console: bundle exec pry -r ./app.rb
