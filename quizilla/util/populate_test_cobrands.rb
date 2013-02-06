Partner.delete_all
PartnerSite.delete_all

#CobrandGroup.create( :name => 'CB Group 1', :deleted_at => nil )
#CobrandGroup.create( :name => 'CB Group 2', :deleted_at => nil )
#CobrandGroup.create( :name => 'CB Group 3', :deleted_at => nil )

#cb_group_ids = CobrandGroup.find(:all).collect {|cbg| cbg.id}

#10.times do |cb|
#  cbg = cb_group_ids[rand(cb_group_ids.size)]
#  Cobrand.create(:key => "cb#{cb}", :host => "www", :domain => "testdomain#{cb}.com", :display_name => "Cobrand Name #{cb}", :cobrand_group_id => cbg)
#end

Partner.create( :name => 'Synapse', :deleted_at => nil )
syn_group_id = Partner.find_by_name( 'Synapse' )
PartnerSite.create(:key => "af-entertainment", :host => "af-entertainment", :domain => "synapsetest.com", :display_name => "American Family Entertainment", :partner_id => syn_group_id )
PartnerSite.create(:key => "af-sports", :host => "af-sports", :domain => "synapsetest.com", :display_name => "American Family Sports", :partner_id => syn_group_id )
PartnerSite.create(:key => "af-travel", :host => "af-travel", :domain => "synapsetest.com", :display_name => "American Family Travel", :partner_id => syn_group_id )
PartnerSite.create(:key => "af-home", :host => "af-home", :domain => "synapsetest.com", :display_name => "American Family Home", :partner_id => syn_group_id )
PartnerSite.create(:key => "af-health", :host => "af-health", :domain => "synapsetest.com", :display_name => "American Family Health", :partner_id => syn_group_id )

