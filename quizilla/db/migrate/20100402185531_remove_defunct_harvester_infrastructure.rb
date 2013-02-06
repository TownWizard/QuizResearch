class RemoveDefunctHarvesterInfrastructure < ActiveRecord::Migration
  def self.up
    
    drop_table :sources
    drop_table :catalog_states
    drop_table :document_weights
    drop_table :gatherer_realtime_reports
    drop_table :items
    drop_table :item_phrase_correlations
    drop_table :phrases
    drop_table :phrase_aliases
    drop_table :quiz_category_cobrand_bindings

  end

  def self.down
  end
end
