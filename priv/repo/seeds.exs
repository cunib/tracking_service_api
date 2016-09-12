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
  
  }
] |> Enum.each(&Repo.insert!(&1))

 delivery_men = [
   %{
      username: "gago"
   },
   %{
      username: "fabricio"
   },
   %{
      username: "mariano"
   },
 ]

Repo.transaction fn ->
  Repo.all(Business) |> Enum.each(fn(business) ->
    Enum.each(delivery_men, fn(delivery_man) ->
      new_delivery_man = Ecto.build_assoc(business, :delivery_men, Map.put(delivery_man, :business_id, business.id))
      Repo.insert!(new_delivery_man)
    end)
  end)
end
