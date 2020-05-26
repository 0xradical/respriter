shared_examples "json api" do

  before(:example) do
    sign_in_as_admin
    get send("api_admin_v2_#{resource.class.to_s.downcase}_path", resource)
  end

  it 'has a data root level key' do
    expect(json_payload['data']).to be_present
  end

  it 'has an id key' do
    expect(json_payload['data']['id']).to be_present
  end

  it 'has a type key' do
    expect(json_payload['data']['type']).to be_present
  end

  # it 'has an attributes key' do
    # expect(json_payload['data']['attributes']).to be_present
  # end

end
