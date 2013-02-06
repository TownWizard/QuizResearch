# This file provides a method to sort hash and add it to Hash library
# In ruby 1.8, hash sorting does not work and adding new member to hash also not done in order
# To avoid it, there is an implementation of OrderedHash which is an inherited class of Hash
# Adding new member to OrderedHash never change the order of each elements in hash
# Ruby 1.9 supports OrderedHash by default, but ruby 1.8 does not have such an implementation
# So one gem named 'orderedhash' should have installed in order to use it and require it in environment.rb file
#
class Hash
  def sorted_hashes
    hsh = self.sort
    oh = ::OrderedHash.new
    hsh.each do |sh|
      oh[sh[0]] = sh[1]
    end
    return oh
  end
end