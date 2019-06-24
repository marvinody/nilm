module Main exposing (Model, Msg(..), init, main, signUp, update, view)

import Browser
import Browser.Navigation as Nav
import Data exposing (..)
import Html exposing (Html, a, button, div, form, h1, img, input, text)
import Html.Attributes exposing (class, disabled, href, name, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http exposing (..)
import Routes
import Task
import Time
import Url


base_url =
    "http://localhost:4000/api"


users_url =
    base_url ++ "/users"


me_url =
    users_url ++ "/me"


login_url =
    users_url ++ "/login"


posts_url =
    base_url ++ "/posts"



---- MODEL ----


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , email : String
    , password : String
    , name : String
    , user : User
    , posts : Posts
    , error : String
    , displayLogin : Bool
    , route : Routes.Route
    , time : Time.Posix
    }


init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url "" "" "" newUser [] "" True (Routes.parse url) (Time.millisToPosix 0)
    , Cmd.batch
        [ fetchPostsAndTime
        , fetchSelf
        ]
    )


newUser =
    User 0 ""



---- UPDATE ----


type Msg
    = Login
    | SignUp
    | SetTime Time.Posix
    | SetEmail String
    | SetName String
    | SetPassword String
    | GotInitialUser (Result Http.Error User)
    | GotUser (Result Http.Error User)
    | GotPosts (Result Http.Error Posts)
      -- | Error Http.Error
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | ToggleAccountCreation
    | RemoveError


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTime time ->
            ( { model | time = time }, Cmd.none )

        SetEmail email ->
            ( { model | email = email }, Cmd.none )

        SetName name ->
            ( { model | name = name }, Cmd.none )

        SetPassword password ->
            ( { model | password = password }, Cmd.none )

        ToggleAccountCreation ->
            ( { model | displayLogin = not model.displayLogin }, Cmd.none )

        GotUser result ->
            case result of
                Ok user ->
                    ( { model | user = user, error = "" }, Cmd.none )

                Err err ->
                    ( { model | error = errorToString err }, Cmd.none )

        GotInitialUser result ->
            case result of
                Ok user ->
                    ( { model | user = user, error = "" }, Cmd.none )

                -- don't care about this error because this is bg info
                Err _ ->
                    ( model, Cmd.none )

        GotPosts result ->
            case result of
                Ok posts ->
                    ( { model | posts = posts, error = "" }, Cmd.none )

                Err err ->
                    ( { model | error = errorToString err }, Cmd.none )

        SignUp ->
            ( model, signUp model )

        Login ->
            ( model, login model )

        RemoveError ->
            ( { model | error = "" }, Cmd.none )

        UrlChanged url ->
            ( { model | url = url }, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )


signUp : Model -> Cmd Msg
signUp model =
    Http.post
        { url = users_url
        , body =
            Http.jsonBody
                (signUpEncoder
                    model.email
                    model.name
                    model.password
                )
        , expect = Http.expectJson GotUser userDecoder
        }


login : Model -> Cmd Msg
login model =
    Http.post
        { url = login_url
        , body =
            Http.jsonBody (loginEncoder model.name model.password)
        , expect = Http.expectJson GotUser userDecoder
        }


fetchPostsAndTime : Cmd Msg
fetchPostsAndTime =
    Cmd.batch
        [ fetchTime
        , fetchPosts
        ]


fetchTime : Cmd Msg
fetchTime =
    Task.perform SetTime Time.now


fetchPosts : Cmd Msg
fetchPosts =
    Http.get
        { url = posts_url
        , expect = Http.expectJson GotPosts postsDecoder
        }


fetchSelf : Cmd Msg
fetchSelf =
    Http.get
        { url = me_url
        , expect = Http.expectJson GotInitialUser userDecoder
        }



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "Nilm"
    , body =
        [ div [ class "main container" ]
            [ viewError model
            , div [ class "container" ]
                [ viewPosts model
                , div [ class "side-info container" ]
                    [ viewWelcome model
                    , viewAuth model
                    ]
                ]
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


viewAuth : Model -> Html Msg
viewAuth model =
    case model.user.id of
        0 ->
            case model.displayLogin of
                True ->
                    viewLogin model

                False ->
                    viewSignUp model

        _ ->
            div [] []


viewLogin : Model -> Html Msg
viewLogin model =
    form [ onSubmit Login, class "auth container" ]
        [ viewInput "text" "Name" model.name SetName
        , viewInput "text" "Password" model.password SetPassword
        , button [ onClick Login ] [ text "Login" ]
        , div [ class "account-toggle", onClick ToggleAccountCreation ] [ text "No account? Click here to sign up" ]
        ]


viewSignUp : Model -> Html Msg
viewSignUp model =
    form [ onSubmit SignUp, class "auth container" ]
        [ viewInput "text" "Name" model.name SetName
        , viewInput "text" "Email" model.email SetEmail
        , viewInput "text" "Password" model.password SetPassword
        , button [ onClick SignUp ] [ text "Sign Up" ]
        , div [ class "account-toggle", onClick ToggleAccountCreation ] [ text "Have an account? Click here to login" ]
        ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewWelcome : Model -> Html Msg
viewWelcome model =
    case model.user.id of
        0 ->
            h1 [] [ text "Welcome to Nilm" ]

        _ ->
            h1 [] [ text ("Welcome, " ++ model.user.name) ]


viewPosts : Model -> Html Msg
viewPosts model =
    div [ class "posts container" ] (List.map viewPost model.posts)


viewPost : Post -> Html Msg
viewPost post =
    let
        post_url =
            "/p/" ++ String.fromInt post.id

        user_url =
            "/u/" ++ post.author.name
    in
    div [ class "post container" ]
        [ div [ class "post title" ]
            [ a [ href post_url ] [ text post.title ]
            ]
        , div [ class "post author" ]
            [ a [ href user_url ] [ text post.author.name ] ]

        -- , div [ class "post body" ] [ text post.body ]
        ]



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
