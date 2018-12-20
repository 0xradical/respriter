class AlterPaymentsAndEnrollmentsRelation < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :enrollment_id,     :uuid
    add_column :payments, :ext_click_date,    :datetime
    add_column :payments, :ext_id,            :string
    add_column :payments, :compound_ext_id,   :string

    add_index  :payments, :compound_ext_id, unique: true
    add_index  :payments, :enrollment_id

    remove_column :enrollments, :payment_id, :integer

    enable_extension 'uuid-ossp'

    add_column :enrollments, :uuid, :uuid, default: "uuid_generate_v4()", null: false

    rename_column :payments, :amount, :earnings_amount

    change_table :enrollments do |t|
      t.remove :id
      t.rename :uuid, :id
    end

    execute "ALTER TABLE enrollments ADD PRIMARY KEY (id);"

    Enrollment.reset_column_information
    Enrollment.update_all('id = click_id')

    remove_column :enrollments, :click_id

    rename_table :payments, :tracked_actions

    execute <<-SQL
      CREATE OR REPLACE FUNCTION gen_compound_ext_id() RETURNS TRIGGER AS'
      BEGIN
        NEW.compound_ext_id = concat(NEW.source,''_'',NEW.ext_id);
        return NEW;
      END
      'language plpgsql;

      CREATE TRIGGER set_compound_ext_id
      BEFORE INSERT ON public.tracked_actions
      FOR EACH ROW
      EXECUTE PROCEDURE gen_compound_ext_id()
    SQL

  end
end
