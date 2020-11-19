# Synchronization ⌚️

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
