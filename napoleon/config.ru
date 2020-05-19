require_relative 'app'

map '/que' do
  run Que::Web
end

Que::Web.use(Rack::Auth::Basic) do |username, password|
  User.authenticated? username, password
end

map '/' do
  run NapoleonApp
end
