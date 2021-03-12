# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EventApp.Repo.insert!(%EventApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Based on Nat Tucks Lecture code
defmodule Inject do
  alias EventApp.Repo
  alias EventApp.Accounts.User
  alias EventApp.Events.Event

  alice = Repo.insert!(%User{name: "Alice", email: "alice@gmail.com"})
  Repo.insert!(%Event{user_id: alice.id, name: "Alice's Birthday Bash",
                     date: ~D[2023-08-17], description: "There will be Pizza"})

end
