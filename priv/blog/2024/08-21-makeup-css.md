%{
    title: "Creating makeup_css to highlight css",
    tags: ~w(css nimble_publisher makeup nimble_parsec makeup_css),
    description: "Overview of first steps towards a CSS lexer for makeup",
    author: "@begedinnikola",
}
---
# Introduction

A day or so ago, I forked a WIP package called [`makeup_js`](https://hex.pm/packages/makeup_js) and then very soon published [`makeup_ts`](https://hex.pm/packages/makeup_ts).

Initially, I was intimidated by NimbleParsec as well as the look and feel of the code for the currently well-developed highlighters for elixir and erlang.

However, digging into and creating `makeup_ts` told me it's possible to create something useful, if not accademically accurate, with not a lot of effort.

So today, I gave CSS a try.

# The process

I started off by looking at the lexers for Elixir and TypeScript, trying to get a basic understanding of how NimbleParsec works.

Then, I actually went and read the docs for NimbleParsec.

Turns out, it only looks complicated.

A lexer is effectively a 2-pass thing that first uses the NimbleParsec combinators you defined to get an initial list of tokens.

Combinators are affectively declared patters for your code. For example, css [at-rules]() are a list of reserved words, all starting with an `@`, so you end up with something like:

```elixir
# a chain
at_rule_combinator = concat(
  # starting with @
  string("@"), 
  # followed by anything kebap-case
  ascii_string([?a..?z, ?-], min: 1) 
) 
```

This is now a combinator that, when parsing your code, will detect all such strings.

Then, it's about giving those matches one of the categories makeup supports, by calling `token/2`

```elixir
at_rule = token(at_rule_combinator, :keyword_type)
```

So now at rules will be classified as keyword types and given the relevant class, for which the makeup stylesheet will provide styling rules.

We repeat a similar process for rules, class selectors, id selectors, pseudo selectors, operators, functions and keywords, using various functions available within `NimbleParsec` as well as helper functions provided by the `Makeup.Lexer` module and child modules.

For example, we define a combinator and token for css lengths using this:

```elixir
integer = ascii_string([?0..?9], min: 1)

units = word_from_list(
  ~w(cm mm in px pt pc em ex ch rem vw vh vmin vmax %)
)

length =
  integer
  |> optional(concat(string("."), integer))
  |> concat(units)
  |> token(:number_integer)
```

Which causes values like `1em, 1px, 1%`, etc., to be given a `"ni"` class in the output, which is then styled as a number.

There really isn't that much to it. After writing some tests, ordering combinators in the correct way (for example, the rule for property `color:`, clashes wiht selectors like `a:visited`), I got a decent output that I'm somewhat happy with.

# The result

It's not perfect, but for a low amount of effort, we get something useful back, and my `NimblePublisher` blog remains Elixir-only

```css
/* Single line comment */

/*  
    Multiline comment
*/

a[foo],
a[foo=bar],
a [foo=bar] > div, 
a[foo='bar'],
a[foo*='bar'],
a[foo^='bar'],
a[foo$='bar'],
a[foo~='bar'],
a#foo,
a.foo,
a:visited,
a::placeholder,
.foo a {
  border: red;
  width: calc(1px + 1rem) !important;
  height: max(1rem 1vh);
  height: min(1rem 1vh);
  display: grid;
  grid-template-columns: minmax(1vh 2vh) maxmin(1em 1%);
}

a ~ div, 
a + div,
a > div,
a > * {
}

/** at rules */

@media () {

}

@import url('foo.png')

/** variables */

:root {
  --foo: solid 1px black;
}

```

Even better, I don't think there's a lot more work needed to support scss.

You can get the package at [hexdocs: makeup_css](https://hexdocs.pm/makeup_css)

