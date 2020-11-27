[async]: https://github.com/teamcapybara/capybara#asynchronous-javascript-ajax-and-friends
[actions]: /guide/essentials/actions
[assertions]: /guide/essentials/assertions
[finders]: /guide/essentials/finders
[matchers]: /guide/essentials/querying
[using_wait_time]: /api/#using-wait-time
[synchronize_expectation]: /api/#synchronize-expectation
[expectations]: /guide/essentials/assertions.html#using-the-assertion-state

# Synchronization and Waiting ⌚️

In order to prevent race conditions and avoid flaky tests, it's important that any expectations that depend on **asynchronous** outcomes are **retried**.

Most capybara methods will automatically [retry][async] until they succeed or a certain [timeout][using_wait_time] ellapses.

All [finders], [assertions], [matchers], and some [actions] allow passing a `:wait` keyword to specify how many seconds it should be retried before failing or returning control.

## Manual Synchronization ⏱

Automatic synchronization does not apply if you are [writing your own expectations][expectations].

You can make any expectation retry automatically until timeout by wrapping it with [`synchronize_expectation`][synchronize_expectation]:

```ruby
  def be_fullscreen
    synchronize_expectation {
      expect(fullscreen?).to_or not_to, eq(true)
    }
  end
```

## Automatic Reload ♻️

Elements will be automatically reloaded by Capybara as the block is retried, so it works nicely with any element methods.

```ruby
def be_checked
  synchronize_expectation(wait: 3) { expect(checked?).to_or not_to, eq(true) }
end
```

::: tip
Using strict settings will prevent flaky tests and save you time in the long run.

```ruby
Capybara.configure do |config|
  config.default_max_wait_time = 2
  config.exact = true
  config.match = :smart
  config.ignore_hidden_elements = true
end
```
:::
