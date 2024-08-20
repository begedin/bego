%{
    title: "How I got Synthax Higlighting for Typescript to Work",
    tags: ~w(typescript nimble_publisher makeup nimble_parsec makeup_ts),
    description: "Overview of first steps towards a typescript lexer for makeup",
    author: "@begedinnikola",
}
---
# The problem

I'm a full stack developer and I usually work with elixir, typescript, html and css. My FE framework of choice is Vue.

This blog is built with [NimblePublisher](https://github.com/dashbitco/nimble_publisher) which uses markdown and relies on [Makeup](https://github.com/elixir-makeup/makeup) for synthax highlgithing in code blocks.

Makeup does not support highlighting for Typescript, CSS, SCSS or .vue single file components, 1st or 3rd party.

# The research

I looked at what's available out there first

The [makeup](https://github.com/elixir-makeup/makeup) base library is part of the [elixir_makeup](https://github.com/elixir-makeup) organisation, which owns a few more repositories

- [makeup_c](https://github.com/elixir-makeup/makeup_c)
- [makeup_diff](https://github.com/elixir-makeup/makeup_diff)
- [makeup_eex](https://github.com/elixir-makeup/makeup_eex)
- [makeup_elixir](https://github.com/elixir-makeup/makeup_elixir)
- [makeup_erlang](https://github.com/elixir-makeup/makeup_erlang)
- [makeup_html](https://github.com/elixir-makeup/makeup_html)
- [makeup_json](https://github.com/elixir-makeup/makeup_json)

I'll probably be using most of these, but for me to really be happy, I'd need a few more to cover javascript, typscript, css, scss and vue.

So I did some looking around to see what 3rd party addones there are.

## Javascript/Typescript

There are actually two libraries 

- [makeup_js](https://github.com/maartenvanvliet/makeup_js)
- [makeup_javascript](https://github.com/mohammedzeglam-pg/makeup_javascript/blob/main/lib/makeup/lexers/javascript_lexer.ex)

The first one seems to be further ahead, but both are definitely WIP and rarely active, so I'm not sure they are good targets for contribution.

## Other languages

There are a few more for other languages, some of which are interesting to me

- [makeup_rust](https://github.com/dottorblaster/makeup_rust)
- [makeup_toml](https://github.com/kevinschweikert/makeup_toml)
- [makeup_python](https://github.com/suprafly/makeup_python)
- [makeup_go](https://github.com/tmbb/makeup_go)
- [makeup_java](https://github.com/Quartz563/makeup_java)
- [makeup_swift](https://github.com/jesse-c/makeup_swift)
- [makeup_text](https://github.com/BeaconCMS/makeup_text)
- [makeup_graphql](https://github.com/Billzabob/makeup_graphql)
- [makeup_ruby](https://github.com/BeaconCMS/makeup_ruby)

Some of these are in more advanced state than others.

There is also a cookiecutter (python generator library) template for a makeup lexer

- [makeup_lexer_cookiecutter](https://github.com/tmbb/makeup_lexer_cookiecutter)

But no CSS, no SCSS, no Typescript and definitely no Vue

`makeup_js` actually claims it will support typescript in the future, but doesn't seem to right now. Still, that makes it a good kickoff point, since even as is, it pretty decently highlights.

# Milestone 0: Starting `makeup_ts`

The milestone 1 goal is to fork `makeup_js`, name it `makeup_ts` and extend it with types support. I can then offer the fork as a contribution PR to the base library and see if it gets merged, while giving me something to work with.

But before I do that, I find it easier to just work with code locally, so that's going to be milestone 0 for me and that's the state I got this code highlighted in.

```typescript
// basic declarations highlight types
const foo: Foo = 'bar'

// arrow functions are kind of ok (=> is an operator)
const bar = () => undefined

// named functions with types are also ok
function baz (param: number): number {
    return param + 5;
}

// classes work sufficiently for me (I rarely use them)
class SomeClass {
    constructor(params: Foo, otherParams: Bar)
}

// casting using <> works
const a = <string>('c')

const a = 'b' as const
const a = 'b' as 'a' | 'b'

// generics work ok
const generic = <T extends number>(a: T): number => a * 5

/**
 * also multiline comments
 */
```

It required a bit of tweaking and cleanup of the original .ex file for makeup_js, but it __works__ so milestone 0 is done.

# Milestone 1: Make a fork

The next step is to make this an external library, so that's exactly what I did.

I forked [makeup_js](https://github.com/maartenvanvliet/makeup_js), renamed it to `makeup_ts` and it's now available on [github](https://github.com/begedin/makeup_ts).

I also went ahead and published the package on hexdocs at [packages/makeup_ts](https://hex.pm/packages/makeup_ts).

It's rudimentary, but it's something to start with at least.

# Milestone 2: Use it, tweak it, work on it

I have working typescript code higlighing in my blog now, so I'm happy. 

The next step for me here is to use it to write more articles, tweak it when I encounter issues and make it faster/better as I go.

For example, with `makeup`, `makeup_elixir` and `makeup_ts` attached to my repo, I seem to get a memory usage spike as the app starts up, so I was forced to add swap to my 256mb fly.io instance to get around it. There's probably something in `makeup_ts` causing it.