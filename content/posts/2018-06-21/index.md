---
title: "Setting up an Elixir/Phoenix project for acceptance testing with Cypress"
author: "begedin"
date: "2018-06-21"
slug: "cypress-elixir-phoenix-ecto-sandbox"
cover: ""
category: "tech"
tags:
    - programming
    - elixir
    - phoenix
    - ecto
    - cypress
    - testing
    - e2e
---

# What are we talking about?

Cypress is this awesome new tool that works great with APIs and is as easy to setup as anything if you're mocking out your backend.

For those experienced with ember, it pretty much lets you setup an ember acceptance testing environment, except it can work with almost any framework.

What a lot of people give up on with cypress, though, is the ability to do much more.

By more, I'm talking about the ability to use your actual, real backend.

It's not always achievable, and it certainly requires some work to set up with an Elixir/Phoenix backend, but thanks to a nifty feature Ecto added, it's possible.

You see, Ecto for a long time had a sandbox mode where your tests could run with. What that means is, a test would run in an isolated database transaction of sorts, where you could do anything you want with the data in the database, for it to automatically get reset after the test executes.

Even better, each test runs in each own sandbox, and they can run in parallel with each other, enabling an fast test suite.

Now the thing that Ecto added in one of the newer releases is the ability to autogenerate a set of simple endpoints for your project, if you choose to do so. What this endpoints do is, they checkout and then check in a session **remotely**, meaning any sort of client framework could do it. It's no longer exclusive to tests written in Elixir.

The way it works is

* you check out a session and gain a session key at the start of a test
* you sign all your requests within that test with a header containing that key
* you check out the session at the end of the tests

The end result is, your frontend test runs isolated from other frontend tests, while at the same time being able to access your actual backend, instead of using a fake one.

__More incoming__
