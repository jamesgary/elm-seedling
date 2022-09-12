module Main exposing (..)

import Browser
import Element as E exposing (Element)
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Events as EEvents
import Element.Font as EFont
import Element.Input as EInput
import Flags exposing (Flags)
import Html exposing (Html)
import Json.Decode as JD


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { foo : String }


init : JD.Value -> ( Model, Cmd Msg )
init jsonFlags =
    case JD.decodeValue Flags.decoder jsonFlags of
        Ok flags ->
            ( { foo = "world" }, Cmd.none )

        Err err ->
            ( { foo = JD.errorToString err }, Cmd.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        el =
            E.text ("Hello, " ++ model.foo ++ "!")
    in
    E.layout
        [ E.padding 20 ]
        el
