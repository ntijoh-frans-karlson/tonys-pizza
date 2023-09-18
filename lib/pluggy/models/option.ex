defmodule Pluggy.Option do

    def name_to_id(name) do
        Postgrex.query!(DB, "SELECT id FROM options WHERE name = $1", [name], pool: DBConnection.ConnectionPool).rows |> hd |> hd 
    end

end