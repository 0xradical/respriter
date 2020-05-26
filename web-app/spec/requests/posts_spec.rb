describe 'Posts API', type: :request do

  it_behaves_like 'json api' do
    let(:resource) { create(:filled_post) }
  end

  describe "GET #index" do

    before(:context) do
      sign_in_as_admin
      @posts = create_list(:filled_post, 5)
      get api_admin_v2_posts_path
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the posts' do
      expect(json_payload['data'].size).to eq(5)
    end

    it 'returns the total number of posts' do
      expect(json_payload['meta']['count']).to eq(5)
    end

  end

  describe 'GET #new' do

    before(:context) do
      sign_in_as_admin
      get new_api_admin_v2_post_path
    end

    # it 'creates a void post' do
      # expect(json_payload['data']['id']).to be_present
      # expect(json_payload['data']['attributes']['status']).to eq('void')
    # end

  end

  describe 'GET #show' do

    before(:context) do
      sign_in_as_admin
      @post = create(:filled_post)
      get api_admin_v2_post_path(@post)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    describe 'it returns a json api' do

      it 'has an id' do
        expect(json_payload['data']['id']).to eq(@post.id.to_s)
      end

      it 'has relationships with admin_account' do
        expect(json_payload['data']['relationships']['admin_account']).to be_present
      end

      it 'has relationships with images' do
        expect(json_payload['data']['relationships']['images']).to be_present
      end

      it 'has a type root level key' do
        expect(json_payload['data']['type']).to eq('post')
      end

    end

  end

  describe 'PUT #update' do

    before(:example) do
      admin = sign_in_as_admin
      @post = admin.posts.void
    end

    it "returns an error with model validation errors" do
      put api_admin_v2_post_path(@post), params: { post: { tags: ['foo'] } }
      payload = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(payload['errors'][0]['source']['pointer']).to eq('/data/attributes/title')
      expect(payload['errors'][1]['source']['pointer']).to eq('/data/attributes/body')
    end

    # it "updates a void post" do
      # put  api_admin_v2_post_path(@post), params: { post: { title: 'Um título não ascii $$', body: 'Hello World' } }
      # payload = JSON.parse(response.body)
      # expect(response).to have_http_status(:success)
      # expect(payload['data']['attributes']['status']).to eq('draft')
      # expect(payload['data']['attributes']['slug']).to eq('um-titulo-nao-ascii')
      # expect(payload['data']['attributes']['title']).to eq('Um título não ascii $$')
      # expect(payload['data']['attributes']['body']).to eq('Hello World')
    # end

  end

  describe 'DELETE #destroy' do

    before(:context) do
      sign_in_as_admin
      @post = create(:filled_post)
      delete api_admin_v2_post_path(@post)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'destroys the post' do
      expect(Post.count).to eq(0)
    end

  end


end
