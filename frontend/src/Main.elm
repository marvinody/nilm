module Main exposing (Model, Msg(..), init, main, signUp, update, view)

import Browser
import Browser.Navigation as Nav
import Data exposing (User, signUpEncoder, userDecoder)
import Html exposing (Html, a, button, div, h1, img, input, text)
import Html.Attributes exposing (href, name, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Http exposing (..)
import Url



---- MODEL ----


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , email : String
    , password : String
    , name : String
    , user : User
    , error : String
    }


init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url "" "" "" newUser "", Cmd.none )


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
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | RemoveError


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
                    ( { model | user = user, error = "" }, Cmd.none )

                Err err ->
                    ( { model | error = errorToString err }, Cmd.none )

        SignUp ->
            ( model, signUp model )

        RemoveError ->
            ( { model | error = "" }, Cmd.none )

        UrlChanged url ->
            ( { model | url = url }, Cmd.none )

        _ ->
            ( model, Cmd.none )


signUp : Model -> Cmd Msg
signUp model =
    Http.post
        { url = "http://localhost:4000/api/users"
        , body =
            Http.jsonBody
                (signUpEncoder
                    model.email
                    model.name
                    model.password
                )
        , expect = Http.expectJson GotUser userDecoder
        }



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "Nilm"
    , body =
        [ div []
            [ viewError model
            , img [ src "/logo.svg" ] []
            , h1 [] [ text "Hello world" ]
            , viewSignUp model
            ]
        ]
    }


viewError : Model -> Html Msg
viewError model =
    case model.error of
        "" ->
            div [] []

        _ ->
            div [ onClick RemoveError ]
                [ text model.error
                ]


viewSignUp : Model -> Html Msg
viewSignUp model =
    div []
        [ viewInput "text" "Name" model.name SetName
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
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


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
