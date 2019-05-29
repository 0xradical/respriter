describe Search::CourseSearch do
  DEFAULT_PAGE_SIZE = 25

  describe 'simplest searches' do
    database_clean

    before :all do
      @courses = 10.times.map{ create :course }
      Course.reindex!
      wait_for_indexing
    end

    it 'should be able to get all resources' do
      ids = Search::CourseSearch.new.results[:data].map{ |d| d[:id] }.sort
      expect(ids).to eq( @courses.map(&:id).sort )
    end

    it 'should not unmatched stuff' do
      data = Search::CourseSearch.new(query: 'Xinforinfula').results[:data]
      expect(data).to be_blank
    end
  end

  describe 'ordering results' do
    database_clean

    before :all do
      @courses = 10.times.map do |n|
        name = [
          'Beagle',
          *(10.times.map{ (rand > 0.50) ? 'Beagle' : 'Owl' }),
          "##{n}"
        ].shuffle.join ' '
        price = (rand > 0.20) ? rand(1..20000) / 100.0 : 0
        create :course, name: name, price: price
      end

      Course.reindex!
      wait_for_indexing
    end

    it 'sort by search score' do
      data = Search::CourseSearch.new(query: 'Beagle').results[:data]

      beagle_score = data.map do |result|
        tally = result[:name].split.group_by(&:itself).map{ |name, names| [name, names.size] }.to_h
        tally['Beagle'].to_f / (tally['Beagle'] + (tally['Owl'] || 0) + 1)
      end

      beagle_score.each_cons(2) do |score, next_score|
        expect(score).to be >= next_score
      end

      # beagle_score does not contains a precise equal Elasticsearch score,
      # but this tests tries to ensure that if some term appears with more
      # frequency in a given result then this result is somehow more relevant.
      #
      # This is not true everytime because ElasticSeach algorithm penalizes
      # bigger fields, considering that fields with fewer terms are more
      # important than those with more fields.
      #
      # Knowing that, this beagle_score should hold an injective mapping over
      # ElasticSearch score only if fields have same number of terms.
      #
      # For better understanding of BM25, the default score algorithm of,
      # ElasticSearch read this:
      # https://www.elastic.co/guide/en/elasticsearch/guide/master/pluggable-similarites.html#bm25
    end

    it 'sort by lowest prices' do
      prices = Search::CourseSearch.new(query: 'Beagle', order: [['price', 'asc']]).results[:data].map{ |d| d[:price] }
      prices.each_cons(2) do |price, next_price|
        expect(price).to be <= next_price
      end
    end

    it 'sort by highest prices' do
      prices = Search::CourseSearch.new(query: 'Beagle', order: [['price', 'desc']]).results[:data].map{ |d| d[:price] }
      prices.each_cons(2) do |price, next_price|
        expect(price).to be >= next_price
      end
    end
  end

  describe 'paging with divisible amount of courses' do
    database_clean

    before :all do
      @courses = (DEFAULT_PAGE_SIZE*2).times.map{ create :course }
      Course.reindex!
      wait_for_indexing
    end

    it 'first page gets default size as number of results' do
      first_ids = Search::CourseSearch.new.results[:data].map{ |d| d[:id] }.sort
      expect(first_ids.uniq.size).to eq DEFAULT_PAGE_SIZE

      first_ids_again = Search::CourseSearch.new(page: 1).results[:data].map{ |d| d[:id] }.sort
      expect(first_ids_again).to eq first_ids

      second_ids = Search::CourseSearch.new(page: 2).results[:data].map{ |d| d[:id] }.sort
      expect(second_ids.uniq.size).to eq DEFAULT_PAGE_SIZE
    end

    it 'first page gets 5 results per query if that is required' do
      full_pages = @courses.size / 5

      full_pages.times do |n|
        ids = Search::CourseSearch.new(page: n+1, per_page: 5).results[:data].map{ |d| d[:id] }.sort
        expect(ids.uniq.size).to eq 5
      end

      data = Search::CourseSearch.new(page: full_pages + 1, per_page: 5).results[:data]
      expect(data).to be_blank
    end
  end

  describe 'paging with indivisible amount of courses' do
    database_clean

    before :all do
      @courses = (DEFAULT_PAGE_SIZE*2 + rand(1..(DEFAULT_PAGE_SIZE-1))).times.map{ create :course }
      Course.reindex!
      wait_for_indexing
    end

    it 'first page gets default size as number of results' do
      first_ids = Search::CourseSearch.new.results[:data].map{ |d| d[:id] }.sort
      expect(first_ids.uniq.size).to eq DEFAULT_PAGE_SIZE

      first_ids_again = Search::CourseSearch.new(page: 1).results[:data].map{ |d| d[:id] }.sort
      expect(first_ids_again).to eq first_ids

      second_ids = Search::CourseSearch.new(page: 2).results[:data].map{ |d| d[:id] }.sort
      expect(second_ids.uniq.size).to eq DEFAULT_PAGE_SIZE

      third_ids = Search::CourseSearch.new(page: 3).results[:data].map{ |d| d[:id] }.sort
      expect(third_ids.uniq.size).to eq(@courses.size % DEFAULT_PAGE_SIZE)
    end

    it 'first page gets 5 results per query if that is required' do
      full_pages = @courses.size / 5

      full_pages.times do |n|
        ids = Search::CourseSearch.new(page: n+1, per_page: 5).results[:data].map{ |d| d[:id] }.sort
        expect(ids.uniq.size).to eq 5
      end

      ids = Search::CourseSearch.new(page: full_pages + 1, per_page: 5).results[:data].map{ |d| d[:id] }.sort
      expect(ids.uniq.size).to eq(@courses.size % 5)
    end
  end

  describe 'simple english search' do
    database_clean

    before :all do
      @courses = [
        create(:course, name: '1st Learning Ruby',     tags: [ 'Programming' ], description: 'Basic Course on Matsumoto\'s Programming Language'),
        create(:course, name: '2nd Learn Programming', tags: [ 'Ruby'        ], description: 'Basic Course on Matsumoto\'s Programming Language'),
        create(:course, name: '3rd Programming',       tags: [ 'Programming' ], description: 'Learn Ruby Programming Language'),
        create(:course, name: '4th Programming',       tags: [ 'Programming' ], description: 'Basic Course on Python'),
      ]
      Course.reindex!
      wait_for_indexing
    end

    it 'should be able to find by name, tag and description' do
      ids = Search::CourseSearch.new(query: 'Ruby').results[:data].map{ |d| d[:id] }.sort
      expect(ids).to eq( @courses[0..2].map(&:id).sort )
    end

    it 'should apply english stemmer' do
      ids = Search::CourseSearch.new(query: 'Learns').results[:data].map{ |d| d[:id] }.sort
      expect(ids).to eq( @courses[0..2].map(&:id).sort )
    end

    it 'should not understand portuguese' do
      data = Search::CourseSearch.new(query: 'Aprende').results[:data]
      expect(data).to be_blank
    end

    it 'should be able to find tokenized tags' do
      ids = Search::CourseSearch.new(query: 'ruby').results[:data].map{ |d| d[:id] }.sort
      expect(ids).to eq( @courses[0..2].map(&:id).sort )
    end
  end

  describe 'simple portuguese search' do
    database_clean

    before :all do
      @courses = [
        create(:course, name: '#1 Aprenda Ruby',         tags: [ 'Programação' ], description: 'Curso Básico de Programação com Matsumoto'),
        create(:course, name: '#2 Aprendas Programação', tags: [ 'Ruby'        ], description: 'Curso Básico de Programação com Matsumoto'),
        create(:course, name: '#3 Programação',          tags: [ 'Programação' ], description: 'Aprenda Programação com Ruby'),
        create(:course, name: '#4 Programação',          tags: [ 'Programação' ], description: 'Curso Básico de Python'),
      ]
      Course.reindex!
      wait_for_indexing
    end

    it 'should apply portuguese stemmer' do
      ids = Search::CourseSearch.new(query: 'Aprender').results[:data].map{ |d| d[:id] }.sort
      expect(ids).to eq( @courses[0..2].map(&:id).sort )
    end

    it 'should not understand english' do
      data = Search::CourseSearch.new(query: 'Learn').results[:data]
      expect(data).to be_blank
    end
  end

  describe 'simple spanish search' do
    database_clean

    before :all do
      @courses = [
        create(:course, name: '#1 Desarrollar con Ruby', tags: [ 'Software' ],  description: 'Curso básico de desarrollo de software'),
        create(:course, name: '#2 Aprendas Desarrollo',  tags: [ 'Ruby'     ], description: 'Curso básico de desarrollo de software'),
        create(:course, name: '#3 Desarrolle',           tags: [ 'Software' ],  description: 'Aprenda Desarrollo com Ruby'),
        create(:course, name: '#4 Software',             tags: [ 'Software' ],  description: 'Curso básico de Python'),
      ]
      Course.reindex!
      wait_for_indexing
    end

    it 'should apply spanish stemmer' do
      ids = Search::CourseSearch.new(query: 'Desarrollo').results[:data].map{ |d| d[:id] }.sort
      expect(ids).to eq( @courses[0..2].map(&:id).sort )
    end

    it 'should not understand english' do
      data = Search::CourseSearch.new(query: 'Learn').results[:data]
      expect(data).to be_blank
    end
  end

  describe 'categories aggregation' do
    database_clean

    before :all do
      @courses = RootTag.all.map(&:id).uniq.map do |category|
        name =  "Course of #{I18n.t "tag.#{category}"} #{(rand > 0.5) ? 'Selected' : 'Missing' }"
        create :course, category: category, name: name
      end

      @grouped_courses = @courses.group_by do |course|
        course.name.match(/Selected|Missing/)[0].downcase.to_sym
      end

      Course.reindex!
      wait_for_indexing
    end

    it 'should include all categories on empty search' do
      categories = Search::CourseSearch.new.results[:meta][:aggregations][:category][:unselected].map &:first
      expect(categories.sort).to eq( RootTag.all.map(&:id).uniq.map(&:to_sym).sort )
    end

    it 'should include all matched categories on search' do
      search = Search::CourseSearch.new(query: 'Selected').results

      selected_categories = search[:meta][:aggregations][:category][:selected].map   &:first
      missing_categories  = search[:meta][:aggregations][:category][:unselected].map &:first

      expect(selected_categories).to be_blank
      expect(missing_categories.map(&:to_sym).sort).to eq( @grouped_courses[:selected].map(&:category).map(&:to_sym).sort )
    end

    it 'should include all matched categories on filtered search' do
      all_categories        = @grouped_courses[:selected].map(&:category).map &:to_sym
      filtered_categories   = all_categories.sample( rand(1..all_categories.size) ).sort
      unfiltered_categories = (all_categories - filtered_categories).sort

      search = Search::CourseSearch.new(query: 'Selected', filter: { category: filtered_categories }).results

      selected_categories = search[ :meta ][ :aggregations ][ :category ][ :selected   ].map(&:first).map(&:to_sym).sort
      missing_categories  = search[ :meta ][ :aggregations ][ :category ][ :unselected ].map(&:first).map(&:to_sym).sort

      expect(selected_categories).to eq( filtered_categories )
      expect(missing_categories).to  eq( unfiltered_categories )
    end
  end

  describe 'providers aggregation' do
    database_clean

    before :all do
      @courses = 50.times.map do |n|
        name = "Course with aggregating provider #{(rand > 0.5) ? 'Selected' : 'Missing' } ##{n+1}"
        create :course, name: name
      end
      @providers = @courses.map &:provider

      @grouped_providers = @courses.group_by do |course|
        course.name.match(/Selected|Missing/)[0].downcase.to_sym
      end.map do |key, courses|
        [
          key,
          courses.map(&:provider)
        ]
      end.to_h

      Course.reindex!
      wait_for_indexing
    end

    it 'should include all providers on empty search' do
      provider_names = Search::CourseSearch.new.results[:meta][:aggregations][:provider_name][:unselected].map &:first
      expect(provider_names.sort).to eq( @providers.map(&:name).uniq.map(&:to_sym).sort )
    end

    it 'should include all matched providers on search' do
      search = Search::CourseSearch.new(query: 'Selected').results

      selected_providers = search[ :meta ][ :aggregations ][ :provider_name ][ :selected   ].map &:first
      missing_providers  = search[ :meta ][ :aggregations ][ :provider_name ][ :unselected ].map &:first

      expect(selected_providers).to be_blank
      expect(missing_providers.sort).to eq( @grouped_providers[:selected].map(&:name).uniq.map(&:to_sym).sort )
    end

    it 'should include all matched providers on filtered search' do
      all_providers        = @grouped_providers[:selected].map(&:name).map &:to_sym
      filtered_providers   = all_providers.sample( rand(1..all_providers.size) ).sort
      unfiltered_providers = (all_providers - filtered_providers).sort

      search = Search::CourseSearch.new(query: 'Selected', filter: { provider_name: filtered_providers }).results

      selected_providers = search[ :meta ][ :aggregations ][ :provider_name ][ :selected   ].map(&:first).sort
      missing_providers  = search[ :meta ][ :aggregations ][ :provider_name ][ :unselected ].map(&:first).sort

      expect(selected_providers).to eq( filtered_providers )
      expect(missing_providers).to  eq( unfiltered_providers )
    end
  end
end
