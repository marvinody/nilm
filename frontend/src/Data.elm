module Data exposing (Post, Posts, User, loginEncoder, postDecoder, postsDecoder, signUpEncoder, userDecoder)

import Json.Decode as D exposing (Decoder)
import Json.Encode as E


signUpEncoder : String -> String -> String -> E.Value
signUpEncoder email name password =
    E.object
        [ ( "email", E.string email )
        , ( "password", E.string password )
        , ( "name", E.string name )
        ]


loginEncoder : String -> String -> E.Value
loginEncoder name password =
    E.object
        [ ( "password", E.string password )
        , ( "name", E.string name )
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


type alias Posts =
    List Post


type alias Post =
    { id : Int
    , title : String
    , body : String
    , user : User
    }


titleDecoder : Decoder String
titleDecoder =
    D.field "title" D.string


bodyDecoder : Decoder String
bodyDecoder =
    D.field "body" D.string


authorDecoder : Decoder User
authorDecoder =
    D.field "author" userDecoder


postDecoder : Decoder Post
postDecoder =
    D.map4 Post
        idDecoder
        titleDecoder
        bodyDecoder
        authorDecoder


postsDecoder : Decoder Posts
postsDecoder =
    D.list postDecoder
