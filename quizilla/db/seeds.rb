
Role.create( :name => 'admin' ) if Role.find_by_name( 'admin' ) == nil
Role.create( :name => 'partner_admin' ) if Role.find_by_name( 'partner_admin' ) == nil
Role.create( :name => 'partner_report_viewer' ) if Role.find_by_name( 'partner_report_viewer' ) == nil
Role.create( :name => 'partner_site_report_viewer' ) if Role.find_by_name( 'partner_site_report_viewer' ) == nil
User.find_by_email( 'admin@maxwelldaily.com' ).roles << Role.find_by_name( 'admin' )
