Capybara.get_test_helper_class(:current_page)

CurrentPageTestHelper::SCREEN_SIZES.each_key do |name|
  Before("@#{ name }") do
    get_test_helper(:current_page).resize_to(name)
  end
end
