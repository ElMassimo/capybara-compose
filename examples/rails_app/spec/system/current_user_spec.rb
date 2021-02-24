RSpec.configure do |config|
  config.before(:each, :current_user) do |example|
    example.example_group_instance.define_singleton_method(:current_user) {
      instance_exec(&example.metadata[:current_user])
    }
  end
end

RSpec.feature 'Visiting a page' do
  before { puts current_user }

  it 'can visit the page', current_user: -> { 'Hey' } do

  end
end
