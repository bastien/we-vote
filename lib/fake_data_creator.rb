class FakeDataCreator

  def start
    users = generate_users
    create_delegations(users)
  end
  
  def generate_users
    users = []
    1000.times do
      user = User.create!(:name => Faker::Name.name + "(fake)", :email => Faker::Internet.email, :password => "123456", :password_confirmation => "123456")
      user.update_attribute(:confirmed_at, Time.now)
      users << user
    end
    users
  end
  
  def create_delegations(users)
    users.each do |user|
      used_users = [user]
      (rand(4) + 1).times do
        delegated = nil
        while delegated.nil? do
          delegated = users[rand(1000)]
          delegated = nil if used_users.include? delegated
        end
        Delegation.create!(:delegatee_id => user.id, :delegated_id => delegated.id)
      end
    end
  end

end