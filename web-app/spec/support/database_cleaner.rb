module Support
  module DatabaseCleaner
    def database_clean(cleaning_method = :truncation)
      before :all do
        ::DatabaseCleaner.clean_with cleaning_method
      end

      after :all do
        ::DatabaseCleaner.clean_with cleaning_method
      end
    end
  end
end
