module Main exposing (Model, Msg(..), init, main, signUp, update, view)

import Browser
import Html exposing (Html, button, div, h1, img, input, text)
import Html.Attributes exposing (name, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Http exposing (..)
import Json.Decode as D exposing (Decoder)
import Json.Encode as E



---- MODEL ----


type alias Model =
    { email : String
    , password : String
    , name : String
    , user : User
    , error : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" "" "" newUser ""
    , Cmd.none
    )


newUser =
    User 0 ""



---- UPDATE ----


type Msg
    = NoOp
    | Login
    | SignUp
    | SetEmail String
    | SetName String
    | SetPassword String
    | GotUser (Result Http.Error User)
    | Error Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetEmail email ->
            ( { model | email = email }, Cmd.none )

        SetName name ->
            ( { model | name = name }, Cmd.none )

        SetPassword password ->
            ( { model | password = password }, Cmd.none )

        GotUser result ->
            case result of
                Ok user ->
                    ( { model | user = user }, Cmd.none )

                Err err ->
                    ( { model | error = errorToString err }, Cmd.none )

        SignUp ->
            ( model, signUp model )

        _ ->
            ( model, Cmd.none )


signUp : Model -> Cmd Msg
signUp model =
    Http.post
        { url = "http://localhost:4000/api/users"
        , body = Http.jsonBody (signUpBody model)
        , expect = Http.expectJson GotUser userDecoder
        }


signUpBody : Model -> E.Value
signUpBody model =
    E.object
        [ ( "email", E.string model.email )
        , ( "password", E.string model.password )
        , ( "name", E.string model.name )
        ]


type alias User =
    { id : Int
    , name : String
    }


userDecoder : Decoder User
userDecoder =
    D.map2 User
        idDecoder
        nameDecoder


idDecoder : Decoder Int
idDecoder =
    D.field "id" D.int


nameDecoder : Decoder String
nameDecoder =
    D.field "name" D.string



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Hello world" ]
        , viewInput "text" "Name" model.name SetName
        , viewInput "text" "Email" model.email SetEmail
        , viewInput "text" "Password" model.password SetPassword
        , button [ onClick SignUp ] [ text "Sign Up" ]
        ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }


errorToString : Http.Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "The URL " ++ url ++ " was invalid"

        Timeout ->
            "Unable to reach the server, try again"

        NetworkError ->
            "Unable to reach the server, check your network connection"

        BadStatus 500 ->
            "The server had a problem, try again later"

        BadStatus 400 ->
            "Verify your information and try again"

        BadStatus _ ->
            "Unknown error"

        BadBody errorMessage ->
            errorMessage
