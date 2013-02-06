module Publishers::BaseHelper
  def xml_timestamps xml, obj
    xml.created_at obj.created_at
    xml.updated_at obj.updated_at
  end
end
