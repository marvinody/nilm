module Data exposing (User, signUpEncoder, userDecoder)

import Json.Decode as D exposing (Decoder)
import Json.Encode as E


signUpEncoder : String -> String -> String -> E.Value
signUpEncoder email name password =
    E.object
        [ ( "email", E.string email )
        , ( "password", E.string password )
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
