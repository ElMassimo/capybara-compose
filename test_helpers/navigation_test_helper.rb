# frozen_string_literal: true

class NavigationTestHelper < BaseTestHelper
# Actions: Encapsulate complex actions to provide a cleaner interface.
  # Public: Visits a page defined under the specified alias.
  #
  # NOTE: It can handle sporadic timeout issues.
  def visit_page(page_alias, **options)
    visit path_for(page_alias, **options)
  end

# Assertions: Allow to check on element properties while keeping it DRY.
  def be_in_page(page_alias, **options)
    config_options = [:ignore_query, :url, :wait]
    path_options = options.except(*config_options)
    path_or_url = options[:url] ? path_or_url_for(page_alias, **path_options) : path_for(page_alias, **path_options)
    have_current_path(path_or_url, **options.slice(*config_options))
  end

# Background: Helpers to add/modify/delete data in the database or session.

private

  def path_for(*args, **kwargs)
    url_without_domain path_or_url_for(*args, **kwargs)
  end

  def path_or_url_for(page_alias, **_options)
    case page_alias
    when :fixed_header_footer then '/with_fixed_header_footer'
    when :foo then '/foo'
    when :form, :form_page then '/form'
    when :home then '/'
    when :html, :html_page then '/with_html'
    when :html5 then '/with_html5_svg'
    when :js, :js_page then '/with_js'
    when :namespaced then '/with_namespace'
    when :react then '/react'
    when :scopes_page then '/with_scope'
    when :simple then '/path'
    when :scroll_page then '/scroll'
    when :windows_page then '/with_windows'
    else
      raise NotImplementedError, "You need to add the path to :#{ page_alias } on path_for in ./test_helpers/navigation_test_helper.rb"
    end
  end

  def url_without_domain(url)
    uri = URI.parse(url)
    uri.scheme = nil
    uri.host = nil
    uri.port = nil
    uri.to_s
  end
end
