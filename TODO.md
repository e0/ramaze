# Todo

## Specifications

There are quite a few specifications that are still failing, examples of these
specs are the HTTP Digest, the Ramaze command, file dispatches and a few others.

## Sequel Cache

The Sequel cache needs some work. It seems that when used for sessions it keeps creating a new record for every page refresh while it should only create 1 record per actual user. On top of that it seems that it also queries the database quite a lot (2-3 queries on average).

## Documentation

It would be nice if Ramaze would be just as well documented as Innate.
Currently YARD indicates that about 50% is documented, let's see if we can get that to somewhere around 80% - 90%.

## Examples

Perhaps the examples could use a little update, some of the code is quite old (although might still work).

## Rake tasks

There are a few Rake tasks that are somewhat redundant such as rake release:github. Perhaps these should be removed.

## Authentication

The "User" helper doesn't clearly state what return values an authentication callback should send. It also seems to not work at all.