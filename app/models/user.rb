class User < ApplicationRecord
    include Formatters
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
   :validatable, :confirmable, :lockable, :timeoutable
  attr_writer :login
  after_create :send_admin_mail
  has_many :user_role_locations

  def login
   @login || self.email
  end

  # Fetch the current user
  def self.current
    Thread.current[:user]
  end

  # Assign the current user.
  def self.current=(user)
    Thread.current[:user] = user
  end
  # Find the user from ldap response
  def self.from_omniauth(auth)
    where(provider: auth['provider'], uid: auth['info']['nickname']).first
  end

  # Returns full name
  def full_name
    "#{self.first_name} #{self.last_name}"
  end



  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(email).deliver
  end


  # Checking if user has any roles
  def has_roles?
    if self.user_role_locations.blank?
      false
    else
      true
    end
  end
  # This methods checks if user password expired
  # After user login, the sign_in_count is updated to 1 immediately after first login.
  # When set_password is run, there is an option to force non-ldap user to change password
  # when first time login (by setting the password_change_at to a very old date)
  # Hence do not use sign_in_count to force user to change password here.
  def password_expired?
    # return false if self.provider == 'ldap'     # password expiry validation is not for ldap users

    exp_pwd_after = EXPIRE_PASSWORD_AFTER

    pwd_exp_date = (self.password_changed_at.blank? ? self.created_at : self.password_changed_at) + exp_pwd_after

    pwd_expired = (pwd_exp_date.to_date < Time.now.to_date) ? true : false

    return pwd_expired
  end

  # validate password complexity
  def validate_password_complexity

    if self.password.blank?
      return
    end

    pwd_regexpstr = PASSWORD_REGEXPSTR

    if pwd_regexpstr.match(password).blank?
      self.errors[:password] << "must contain 3 out of these 4 groups: big letters, small letters, digits, and symbols from !@#$%^&*()"
      return
    end

    [self.first_name, self.last_name, self.middle_name, self.preferred_name].each do |name|
      if name.blank? == false && (password.downcase.include? name.downcase)
        self.errors[:password] << "cannot include user name"
        break
      end
    end
  end

 # Return the reporting groups (and child groups) that this user has permission
 # to. Takes the permission name as a string to query
 # If user is in 'global' reporting group just return all rep grps
 # If all_levels is true, will return reporting groups from higher and lower hierarchy levels
 def has_permission_where permission, full_object = false, all_levels = false
   p_id = Permission.find_by(name: permission).id
   # global_id = ReportingGroup.find_by(name: "Global").id

   # FYI in this case URL = user role locations
   urls = User
     .select("users.id, user_role_locations.id as url_id, user_role_locations.role_id")
     .joins(:user_role_locations => {:role => :permissions})
     .where("permissions.id = ? AND users.id = ?", p_id, self.id)
   url_ids  = urls.pluck("user_role_locations.id")
 end

 def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

 def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

end
