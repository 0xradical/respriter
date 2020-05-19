module SQLExecute
  extend ActiveSupport::Concern

  def query_execute(sql)
    self.class.connection.execute sql
  end
end
