module Routes exposing (Route, parse)

import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string, top)


type Route
    = Home
    | Post Int String
    | Topic String
    | User String
    | Comment String Int
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Topic (s "topic" </> string)
        , map Post (s "p" </> int </> string)
        , map User (s "user" </> string)
        , map Comment (s "user" </> string </> s "comment" </> int)
        ]


parse : Url.Url -> Route
parse url =
    Maybe.withDefault NotFound (Url.Parser.parse routeParser url)
