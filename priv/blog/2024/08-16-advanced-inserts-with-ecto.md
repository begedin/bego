

%{
  title: "Advanced inserts with Ecto",
  author: "@begedinnikola",
  tags: ~w(elixir ecto postgresql),
  description: "A runthrough of 2 cool things you can do when using `Repo.insert_all` and `Repo.update_all`"
}
---

# Motivation behind this

[Hugo](https://twitter.com/hugobarauna)'s [Elixir Radar](https://elixir-radar.com/) newsletter recently posted this very [useful article on batch updates with ecto](https://geekmonkey.org/updating-multiple-records-with-different-values-in-ecto-repo-update_all/?utm_medium=email&utm_source=elixir-radar) by Fabian Becker, that you should definitely read.

This reminded me of some cool stuff that we used to do with ecto working at [V7](https://www.v7labs.com/) in the early days of the [Darwin](https://www.v7labs.com/darwin) product. We actually no longer do this now, because it's a much larger system, so it's all about caching, rather than overoptimising, but back then, it fixed a bottleneck, got ous out of some serious downtime and improved performance by an order of mangitude.

We still do cool stuff, of course, but just different kinds of cool stuff.

Anyway, this will be a brief on two of these cool things

# Using SQL to specify values, avoiding roundtrips during inserts

The `UNNEST` method Fabian uses in his article to pass in arrays of values for batch updates can also be used with inserts. In fact, you can `Repo.insert_all` a query that does a select of relevant data and it works great.

This has a really good use for aggregates, or for any sort of data transformation.

For a simple example, say you want to track the number of posts and comments on a daily basis. You will have a cron job or something similar.

## Basic solution

```elixir
post_count = Repo.aggregate(Post, :count, :id)
comment_count = Repo.aggregate(Comment, :count, :id)

Repo.insert_all(Metric, [%{
  post_count: post_count, 
  comment_count: comment_count, 
  date: Date.today()
}])
```

This works great, but it requires n extra queries for n fields of the metric. Here, it's just two, so that's fine, but in reality, it will be more, and each could be expensive.

So the tempation is to try and offload that too the db by just doing one complex query.

## Advanced solution

```elixir
source = 
  Post
  |> join(:left, [p], c in Comments, on: true)
  |> select(%{
    post_count: count(p.id),
    comment_count: count(c.id),
    date: fragment("TODAY()")
  })

Repo.insert_all(Metric, source)
```

Ok, so now it's just a single trip to the database, but I can almost guarantee in this basic example, it's overall slower.

In other examples, it often WILL be faster, but not as fast as it could be.

## Sidenote: Our Scenario at V7

In our scenario, we were recording a metric every 30 seconds and it was 7 fields, across 3 or 4 tables. So the join was more efficient than querying separately for each field, but it was still a very expensive join.

Eventually, we got to a point where the it could not finish in 30 seconds, resulting in resource starvation and downtime.

## _Expert_ Solution

We solved it by making use of an insert feature most people aren't aware off. Your source can be a list of maps, but the values for the map keys can be queries returning 1 value.

In the simple example

```elixir
Repo.insert_all(Metric, [%{
  post_count: Post |> select([p], count(p.id)),
  comment_count: Comment |> select([c], count(c.id)),
  date: Date.today()
}])
```

We've eliminated a join, we still do just one trip to the db and it's way faster.

Now, it's not always going to be faster. It really all depends on how expensive your join is. But at some point, as the join gets expensive enough, this approach definitely wins out.


## _Master_ Solution

Of course, as your system becomes more complex, you just won't be dealing with these kinds of optimisations. Instead, you'll have some caching for these counts within Elixir, and simply insert a record using counts in the cache. You'll probably also be recording these metrics in some sort of queue, so that if you get to a point where they get too expensive, you don't end up in downtime.


# Using placeholders in inserts

Let's have a look at the expert solution one more time.

```elixir
Repo.insert_all(Metric, [%{
  post_count: Post |> select([p], count(p.id)),
  comment_count: Comment |> select([c], count(c.id)),
  date: Date.today()
}])
```

This query only inserts one record, and as part of that, it requires passing in one argument, `Date.today()` from Elixir into Postgres. That's fine here, but what if we're in a scenario where we're inserting more records?

For example, we're importing posts from a CSV, timestamps being a common example.

```elixir
now = NaiveDateTime.utc_now
post_data = 
  file
  |> Enum.map(&String.split(&1, "\n"))
  |> Enum.map(&String.split(&1, ","))
  |> Enum.map(fn [title, body] -> 
    %{
      title: title, 
      body: body, 
      inserted_at: now, 
      updated_at: now
    } 
  end)

Repo.insert_all(post, post_data)
```

This will work, but if there are 1000 entries, we are sending 2000 copies of the value `now` into the database. That's inefficient.

The Ecto team thought of this, though, by supporting placeholders.


```elixir
now = NaiveDateTime.utc_now
placeholders = %{now: now}
post_data = 
  file
  |> Enum.map(&String.split(&1, "\n"))
  |> Enum.map(&String.split(&1, ","))
  |> Enum.map(fn [title, body] -> 
    %{
      title: title, 
      body: body, 
      inserted_at: {:placeholder, :now}, 
      updated_at: {:placeholder, :now}
    } 
  end)

Repo.insert_all(post, post_data, placeholders: placeholders)
```

With this approach, we get the same result, but only send a single copy of the value `now`.

Isn't that awesome!?