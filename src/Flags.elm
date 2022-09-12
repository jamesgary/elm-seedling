module Flags exposing (Flags, decoder)

import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Time exposing (Posix)


type alias Flags =
    { queryParams : String
    , windowWidth : Float
    , windowHeight : Float
    , now : Posix
    }


decoder : JD.Decoder Flags
decoder =
    JD.succeed Flags
        |> JDP.required "queryParams" JD.string
        |> JDP.required "windowWidth" JD.float
        |> JDP.required "windowHeight" JD.float
        |> JDP.required "now" (JD.int |> JD.map Time.millisToPosix)
