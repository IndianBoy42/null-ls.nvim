# Contributing

## General

- Before committing, please format Lua files with
  [StyLua](https://github.com/JohnnyMorganz/StyLua) and Markdown files with
  [Prettier](https://github.com/prettier/prettier). Both are available as
  null-ls built-ins.

- Use the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
  style for your commits.

- Squash your commits so that one commit represents one complete change.

- Mark your PR as WIP until it's ready to merge.

- Make sure tests are passing by running `make test` in the root of the project.
  Smaller features / fixes should have unit test coverage, and larger features
  should have E2E coverage.

- We use Plenary's test suite, which uses a stripped-down version of
  [busted](https://github.com/Olivine-Labs/busted). If you're unsure how to
  write tests for your PR, please let us know and we can help.

## Contributing built-ins

- Check if there is an open issue requesting the built-in you are adding and
  mention in your PR that it closes any relevant issue(s).

- Check other built-in sources for examples and, whenever possible, use helpers
  to reduce the number of lines of code in your PR.

- Make sure to add your built-in source to [BUILTINS](BUILTINS.md). Check other
  examples and follow the existing style. Make sure to insert your source's
  documentation in the correct place to maintain alphabetical order!

- A built-in source's arguments are the minimal arguments required for the
  source to work. Leave out non-essential arguments.

- Built-in sources should target the latest available version of the underlying
  program unless there is a compelling and widespread reason to use an older
  version. If older versions require different arguments, mention that in the
  documentation. If they require a different parser, create a separate built-in.

## Sources

### Diagnostics

- Include all the information provided by the source. These are the available
  fields:

```lua
-- make sure ranges are 1-indexed (and offset if not)
local diagnostic = {
    message, -- string
    severity, -- 1 (error), 2 (warning), 3 (information), 4 (hint)
    row, -- number, optional (defaults to first line)
    col, -- number, optional (defaults to beginning of line)
    end_row, -- number, optional (defaults to row)
    end_col, -- number, optional (defaults to end of line),
    source, -- string, optional (defaults to "null-ls")
    code, -- number, optional
}
```

- Try to make sure `col` and `end_col` match the precise range of the
  diagnostic. If you're using our diagnostic helpers, you can use the `offset`
  override to adjust the range.

  An easy way to check the range is to use a theme like
  [tokyonight](https://github.com/folke/tokyonight.nvim) or
  [sonokai](https://github.com/sainnhe/sonokai) that underlines LSP diagnostics.

- Do not include the source's name or code in the message.

- If at all possible, please add one or more tests to check whether your source
  produces the correct output given an actual raw diagnostic. See [the
  existing tests](../test/spec/builtins/diagnostics_spec.lua) for examples.
