[trailing_commas]: https://maximomussini.com/posts/trailing-commas/

## Formatting 📏

Regarding selectors, I highly recommend writing one attribute per line, sorting
them alphabetically (most editors can do it for you), and
[always using a trailing comma][trailing_commas].

```ruby
class DropdownTestHelper < BaseTestHelper
  SELECTORS = {
    el: '.dropdown',
    toggle: '.dropdown-toggle',
  }
```

It will minimize the amount of git conflicts, and keep the history a lot cleaner and more meaningful when using `git blame`.
