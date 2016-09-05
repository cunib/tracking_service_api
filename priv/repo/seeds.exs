# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TrackingServiceApi.Repo.insert!(%TrackingServiceApi.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias TrackingServiceApi.Repo
alias TrackingServiceApi.Business

[
  %Business{
    name: "La esquina",
    address: "Calle 6 y 66, La Plata"
  
  },
  %Business{
    name: "Milonguita",
    address: "Calle 44 num 532"
  
  }

] |> Enum.each(&Repo.insert!(&1))
