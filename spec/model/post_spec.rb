describe Post do

  context 'a void post' do

    before(:context) do
      @post = create(:void_post)
    end

    it 'has a void status' do
      expect(@post).to be_void
    end

    it 'has a blank slug' do
      expect(@post.slug).to be_blank
    end

    it 'has a blank title' do
      expect(@post.title).to be_blank
    end

    it 'has a blank body' do
      expect(@post.body).to be_blank
    end

    it 'has a blank published_at' do
      expect(@post.published_at).to be_blank
    end

    it 'has empty tags' do
      expect(@post.tags).to be_empty
    end

    it 'has empty meta' do
      expect(@post.meta).to be_empty
    end

    it 'has an admin account' do
      expect(@post.admin_account_id).to be_present
    end

    it 'persists a post instance' do
      expect(@post.id).to be_truthy
    end

  end

  describe '.tags' do

    before(:example) do
      @posts = create_list(:draft_post, 5, tags: [])
    end

    it 'returns all posts when tags are empty' do
      expect(Post.tags.count).to eq(5)
    end

    it 'returns posts with one or more tags' do
      @posts.each { |p| p.update(tags: ['computer_science']) }
      @posts[0].update_column(:tags, ['computer_science','python'])
      @posts[1].update_column(:tags, ['computer_science','python', 'test'])
      expect(Post.tags(['computer_science','python']).count).to eq(2)
      expect(Post.tags(['computer_science','python', 'test']).count).to eq(1)
      expect(Post.tags(['computer_science']).count).to eq(5)
    end

  end

  describe '#save_as_draft' do

    before(:example) do
      @post = build(:void_post)
      @post_attributes = attributes_for(:filled_post)
    end

    it 'has a draft status' do
      @post.save_as_draft(@post_attributes)
      expect(@post).to be_draft
    end

    it 'updates post with attributes' do
      expect(@post).to receive(:update).with(@post_attributes)
      @post.save_as_draft(@post_attributes)
    end

  end

  it 'generates a slug from the title' do
    post = create(:draft_post, { title: 'Um título não ASCII precisa ser transliterado' })
    expect(post.slug).to eq('um-titulo-nao-ascii-precisa-ser-transliterado')
  end




end
