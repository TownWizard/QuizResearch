class User < ActiveRecord::Base
  
  def self.for(access_token, expires, facebook_id)
    user = find_or_create_by_facebook_id(facebook_id)
    user.update_attributes( :access_token => access_token,
                            :access_token_expires => Time.at(expires.to_i))
    return user
  end

  def update_fb_user_detail(access_token, expires, facebook_user)
    self.update_attributes( :name_first => facebook_user.fetch("first_name"),
                            :name_last => facebook_user.fetch("last_name"),
                            :profile_link => facebook_user.fetch("link"),
                            :email => facebook_user.fetch("email"),
                            :gender => facebook_user.fetch("gender"),
                            :birthday => facebook_user.fetch("birthday"),
                            :access_token => access_token,
                            :access_token_expires => Time.at(expires.to_i))
  end

  def self.for_facebook_id(facebook_id)
    find_or_create_by_facebook_id(facebook_id)
  end

end
