module Data exposing (Post, Posts, User, loginEncoder, postDecoder, postInputEncoder, postsDecoder, signUpEncoder, userDecoder)

import Iso8601
import Json.Decode as D exposing (Decoder)
import Json.Encode as E
import Time


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


postInputEncoder : String -> String -> E.Value
postInputEncoder title body =
    E.object
        [ ( "title", E.string title )
        , ( "body", E.string body )
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
    , author : User
    , created_at : Time.Posix
    , created_at_iso : String
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
    D.map6 Post
        idDecoder
        titleDecoder
        bodyDecoder
        authorDecoder
        createdAtDecoder
        createdAtISODecoder


postsDecoder : Decoder Posts
postsDecoder =
    D.list postDecoder


createdAtDecoder : Decoder Time.Posix
createdAtDecoder =
    D.field "created_at" Iso8601.decoder


createdAtISODecoder : Decoder String
createdAtISODecoder =
    D.field "created_at" D.string
