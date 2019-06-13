describe Post do

  describe 'creating a record' do

    let(:post) { build(:filled_post) }

    it 'is draft' do
      post.save
      expect(post).to be_draft
    end

    it 'is persisted' do
      post.save
      expect(post).to be_persisted
    end

    %w(title body locale).each do |val|
      describe "validates presence of #{val}" do

        it 'is not valid if nil' do
          post[val] = nil
          post.save
          expect(post).not_to be_valid
        end

        it 'is not valid if blank' do
          post[val] = ''
          post.save
          expect(post).not_to be_valid
        end

      end
    end

    context 'when status is void' do

      subject { create(:void_post) }

      context 'and it is a new record' do

        it 'bypasses validation' do
          expect(subject).to be_persisted
        end

        it { is_expected.to be_void }

      end

      context 'and it is a persisted record' do

        it 'validates the model' do
          subject.title = 'Foo bar'
          expect { subject.save! }.to raise_exception(ActiveRecord::RecordInvalid)
        end

        context 'and it is valid' do

          let!(:valid_attributes) { attributes_for(:filled_post) }

          before(:example) do
            subject.assign_attributes(valid_attributes)
            subject.save
            subject.reload
          end

          it 'changes the status to draft' do
            expect(subject).to be_draft
          end

          it 'updates the record' do
            expect(subject).to have_attributes(valid_attributes)
          end

        end

      end

    end

  end

  describe '.tags' do

    let!(:draft_posts) { create_list(:draft_post, 5, tags: []) }

    it 'find all posts when tags are empty' do
      expect(described_class.tags.count).to eq(5)
    end

    it 'find posts containing one or more tags' do
      draft_posts.each { |p| p.update(tags: ['computer_science']) }
      draft_posts[0].update_column(:tags, ['computer_science','python'])
      draft_posts[1].update_column(:tags, ['computer_science','python', 'test'])
      expect(described_class.tags(['computer_science','python']).count).to eq(2)
      expect(described_class.tags(['computer_science','python', 'test']).count).to eq(1)
      expect(described_class.tags(['computer_science']).count).to eq(5)
    end

  end

  describe '#publish!' do

    context 'when it is a draft post' do

      subject { create(:draft_post) }

      before(:example) do
        freeze_time do
          @time_now = Time.now
          subject.publish!
        end
      end

      it 'sets the status to published' do
        expect(subject).to be_published
      end

      it 'sets published_at with current time' do
        expect(subject.published_at).to eq(@time_now)
      end

      it 'sets content_changed_at with current time' do
        expect(subject.content_changed_at).to eq(@time_now)
      end

    end

    context 'when it is a disabled post' do

      subject { create(:disabled_post) } 

      it 'sets the status to published' do
        subject.publish!
        expect(subject).to be_published
      end

      it 'does not change published_at' do
        subject.publish!
        expect(subject).not_to be_published_at_changed
      end

    end

  end

  describe '#disable!' do

    subject { create(:published_post) }

    context 'when a post is published' do
      it 'sets the status to disabled' do
        post = create(:published_post)
        post.disable!
        expect(post).to be_disabled
      end
    end

    %w(void draft disabled).each do |status|
      context "when a post status is #{status}" do
        it 'does not change to disabled' do
          post = create("#{status}_post")
          post.disable!
          expect(post).to send("be_#{status}")
        end
      end
    end

  end

  describe 'changes to body' do

    subject! { create(:published_post, body: "<p>Some random content</p>") }

    context 'when only markup has been changed' do

      let(:content_fingerprint) { Digest::MD5.hexdigest("Some random content") }

      before(:example) do
        freeze_time do
          @now = Time.now
          subject.update(body: "<p style='color:red'>Some random <b>content</b></p>")
        end
      end

      it 'does not update content_fingerprint' do
        expect(subject.content_fingerprint).to eq(content_fingerprint)
      end

      it 'does not update content_changed_at' do
        expect(subject.content_changed_at).not_to eq(@now)
      end

    end

    context 'when actual content has been changed' do

      let(:new_content_fingerprint) { Digest::MD5.hexdigest("Some cool content") }

      before(:example) do
        freeze_time do
          @now = Time.now
          subject.update(body: "<p>Some cool content</p>")
        end
      end

      it 'updates content_fingerprint' do
        expect(subject.content_fingerprint).to eq(new_content_fingerprint)
      end

      it 'updates content_changed_at' do
        expect(subject.content_changed_at).to eq(@now)
      end

    end


  end

  it 'generates a slug from the title' do
    post = create(:draft_post, { title: 'Um título não ASCII precisa ser transliterado' })
    expect(post.slug).to eq('um-titulo-nao-ascii-precisa-ser-transliterado')
  end




end
