class Url < ActiveRecord::Base
    belongs_to :user

def valid_url?(uri)
  uri = URI.parse(uri) && !uri.host.nil?
rescue URI::InvalidURIError
  false
end

    

end