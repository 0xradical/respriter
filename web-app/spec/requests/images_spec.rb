describe 'Images API', type: :request do

  describe "POST #create" do

    before :example do
      sign_in_as_admin
      @post = create :filled_post
      image_attributes = attributes_for :image
      post api_admin_v2_post_images_path(@post), params: { image: image_attributes }
    end

    it 'creates an image record' do
      expect(@post.images.count).to eq(1)
    end

    it 'uploads the local file' do
      uploaded_url = @post.images.first.file_url
      local_blob   = File.read(Rails.root.join('spec','assets','test.jpg'))
      local_digest = Digest::MD5.hexdigest local_blob
      expect(uploaded_url).to eq("#{ENV['AWS_S3_ASSET_HOST']}/uploads/test-#{local_digest}.jpg")

      uploaded_blob   = Net::HTTP.get URI("http://assets.s3/uploads/test-#{local_digest}.jpg")
      uploaded_digest = Digest::MD5.hexdigest uploaded_blob

      expect(uploaded_digest).to eq local_digest
    end

  end

end
