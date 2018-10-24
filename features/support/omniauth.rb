OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
  provider: 'github',
  uid: '123545',
  info: {
    email: 'john.doe@quero.com'
  }
})

OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
  provider: 'linkedin',
  uid: '123Ajuy78',
  info: {
    email: 'john.doe@quero.com'
  }
})

