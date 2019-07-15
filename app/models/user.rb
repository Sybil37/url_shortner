# class User < ActiveRecord::Base
#     has_many :urls
# end
class User < ActiveRecord::Base
    has_many :urls
    validates_presence_of :user_name, :email_address
    # validates :email, uniqueness: { case_sensitive: false }
    include BCrypt
  
    def password
      @password ||= Password.new(password_hash)
    end
  
    def password=(new_password)
      @password = Password.create(new_password)
      self.password_hash = @password
    end
end