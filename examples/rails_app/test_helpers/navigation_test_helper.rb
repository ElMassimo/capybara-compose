# frozen_string_literal: true

class NavigationTestHelper < BaseTestHelper
# Actions: Encapsulate complex actions to provide a cleaner interface.
  # Public: Visits a page defined under the specified alias.
  #
  # NOTE: It can handle sporadic timeout issues.
  def visit_page(page_alias, **options)
    visit path_for(page_alias, **options)
  end

# Assertions: Check on element properties, used with `should` and `should_not`.
  # Public: Checks that the current page matches the provided alias.
  def be_in_page(page_alias, **options)
    config_options = [:ignore_query, :url, :wait]
    path_options = options.except(*config_options)
    path_or_url = options[:url] ? path_or_url_for(page_alias, **path_options) : path_for(page_alias, **path_options)
    have_current_path(path_or_url, **options.slice(*config_options))
  end

private

  class UrlsHelper
    include Rails.application.routes.url_helpers
  end

  # Internal: Provides access to all path helpers in Rails.
  def urls
    @@urls ||= UrlsHelper.new
  end

  # Internal: Add aliases here to avoid relying on Rails url helpers directly.
  def path_or_url_for(page_alias, **options)
    case page_alias
    when :cities then urls.cities_path
    when :new_city then urls.new_city_path
    when :edit_city then urls.new_city_path(options.fetch(:city))
    else
      raise NotImplementedError, "You need to add the path to :#{ page_alias } on path_for in ./test_helpers/navigation_test_helper.rb"
    end
  end

  def path_for(*args, **kwargs)
    url_without_domain path_or_url_for(*args, **kwargs)
  end

  def url_without_domain(url)
    uri = URI.parse(url)
    uri.scheme = nil
    uri.host = nil
    uri.port = nil
    uri.to_s
  end
end
