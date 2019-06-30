module Routes exposing (Route(..), parse)

import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string, top)


type Route
    = Home
    | Post Int
    | PostSlug Int String
    | User String
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map Post (s "p" </> int)
        , map PostSlug (s "p" </> int </> string)
        , map User (s "user" </> string)
        ]


parse : Url.Url -> Route
parse url =
    Maybe.withDefault NotFound (Url.Parser.parse routeParser url)
