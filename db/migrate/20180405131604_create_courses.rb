class CreateCourses < ActiveRecord::Migration[5.1]

  def change
    enable_extension 'pgcrypto'

    categories = YAML::load_file(Rails.root.join('config', 'locales', 'en.yml'))['en']['categories'].keys

    execute <<-SQL
      CREATE TYPE category AS ENUM (#{categories.map { |c| "'" + c + "'" }.join(',')});
    SQL

    create_table :courses, id: :uuid do |t|
      t.string :global_sequence
      t.string :name
      t.text :description
      t.string :slug
      t.string :url
      t.string :url_md5, unique: true
      t.string :video_url
      t.decimal :duration_in_hours
      t.decimal :price
      t.decimal :rating
      t.integer :relevance, default: 0
      t.string :region
      t.text :audio, array: true, default: []
      t.text :subtitles, array: true, default: []
      t.boolean :published
      t.boolean :stale, default: false
      t.column :category, :category
      t.references :provider
      t.timestamps
    end

    add_index :courses, :url_md5,     unique: true
    add_index :courses, :slug,        unique: true

    execute <<-SQL
      CREATE OR REPLACE FUNCTION md5_url() RETURNS TRIGGER AS'
      BEGIN
        NEW.url_md5=md5(NEW.url);
        return NEW;
      END
      'language plpgsql;

      CREATE TRIGGER set_global_id
      BEFORE INSERT ON public.courses
      FOR EACH ROW
      EXECUTE PROCEDURE md5_url()
    SQL

  end


end
