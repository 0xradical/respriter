class AddEncodedDeepLinkingToProviders < ActiveRecord::Migration[5.2]
  def change
    add_column :providers, :encoded_deep_linking, :boolean, default: false
  end
end
