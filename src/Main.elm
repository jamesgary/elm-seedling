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
import Http
import Json.Decode as JD
import Json.Encode as JE
import Task exposing (Task)


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
            ( { foo = "world" }
            , [ Http.task
                    { method = "GET"
                    , headers = []
                    , url = "https://jsonplaceholder.typicode.com/todos/1"
                    , body = Http.emptyBody
                    , resolver = Http.stringResolver jsonResolver
                    , timeout = Nothing
                    }
              ]
                |> Task.sequence
                |> Task.attempt GotJson
            )

        Err err ->
            ( { foo = JD.errorToString err }, Cmd.none )


jsonResolver : Http.Response String -> Result Http.Error JD.Value
jsonResolver response =
    case response of
        Http.BadUrl_ url ->
            Err (Http.BadUrl url)

        Http.Timeout_ ->
            Err Http.Timeout

        Http.BadStatus_ { statusCode } _ ->
            Err (Http.BadStatus statusCode)

        Http.NetworkError_ ->
            Err Http.NetworkError

        Http.GoodStatus_ _ body ->
            case JD.decodeString JD.value body of
                Ok result ->
                    Ok result

                Err _ ->
                    Err (Http.BadBody body)



-- UPDATE


type Msg
    = NoOp
    | GotJson (Result Http.Error (List JD.Value))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        GotJson result ->
            case result of
                Ok jsons ->
                    case jsons of
                        [ testJson ] ->
                            let
                                decodeResult =
                                    testJson
                                        |> JD.decodeValue (JD.field "title" JD.string)
                            in
                            case decodeResult of
                                Ok title ->
                                    ( { model | foo = title }, Cmd.none )

                                Err err ->
                                    ( { model | foo = JD.errorToString err }, Cmd.none )

                        _ ->
                            let
                                _ =
                                    Debug.log "unexpected list size" jsons
                            in
                            ( model, Cmd.none )

                Err err ->
                    let
                        _ =
                            Debug.log "error" err
                    in
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
