describe 'Images API', type: :request do

  describe "POST #create" do

    before(:example) do
      sign_in_as_admin
      @post = create(:filled_post)
      image_attributes = attributes_for(:image)
      post api_admin_v2_post_images_path(@post), params: { image: image_attributes }
    end

    it 'creates an image record' do
      expect(@post.images.count).to eq(1)
    end

    it 'uploads the local file' do
      local_blob    = File.read(Rails.root.join('spec','assets','test.jpg'))
      uploaded_blob = File.read(@post.images.first.file_url)
      expect(local_blob).to eq(uploaded_blob)
    end

  end

end
