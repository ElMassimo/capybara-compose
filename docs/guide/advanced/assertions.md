[capybara querying]: https://github.com/teamcapybara/capybara#querying
[should]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L10-L15
[should_not]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L17-L22
[positive and negative assertions]: https://maximomussini.com/posts/cucumber-to_or_not_to/
[assertion state]: /guide/essentials/assertions.html#understanding-the-assertion-state

# Advanced Assertions ⚙️

Sometimes built-in assertions are not enough, and you need to use an expectation
directly.

The _[assertion state]_ is exposed via the `not_to` method (also aliased as `or_should_not`).

Test helpers also provide the [`to_or` method][positive and negative assertions] to easily implement an assertion that you can use with both `should` or `should_not`.

```ruby
class CurrentPageTestHelper < BaseTestHelper
# Getters: A convenient way to get related data or nested elements.
  def fullscreen?
    evaluate_script('!!(document.mozFullScreenElement || document.webkitFullscreenElement)')
  end

# Assertions: Allow to check on element properties while keeping it DRY.
  def be_fullscreen
    expect(fullscreen?).to_or not_to, eq(true)
  end
end

current_page.should.be_fullscreen
current_page.should_not.be_fullscreen
```

## Synchronization ⌚️

In order to prevent race conditions and avoid flaky tests, it's important that any expectation that depends on asynchronous outcomes is retried.

Most Capybara methods will automatically retry until the configured timeout, but this does not apply if you are writing your own assertions.

You can make any expectation retry automatically until the Capybara timeout by
wrapping it with `synchronize_expectation`:

```ruby
  def be_fullscreen
    synchronize_expectation {
      expect(fullscreen?).to_or not_to, eq(true)
    }
  end
```

## Automatic Reload ♻️

Elements will be automatically reloaded by Capybara as the block is retried, so you can use it with matchers or any method in the `Capybara::Node::Element`.

```ruby
class CheckboxTestHelper < BaseTestHelper
  SELECTORS = {
    el: '.checkbox',
  }

  def be_checked
    synchronize_expectation { expect(checked?).to eq(!not_to) }
    self
  end
end

checkbox.should_not.be_checked
```
