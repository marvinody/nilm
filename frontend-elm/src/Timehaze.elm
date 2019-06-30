module Timehaze exposing (elapsed_time)

import Time


minute =
    60


hour =
    minute * 60


day =
    hour * 24


week =
    day * 7


month =
    round (toFloat day * 30.4166)


year =
    month * 12


elapsed_time : Time.Posix -> Time.Posix -> String
elapsed_time old cur =
    let
        oldInt =
            Time.posixToMillis old

        curInt =
            Time.posixToMillis cur

        diffInt =
            curInt - oldInt

        diffInSeconds =
            diffInt // 1000
    in
    agoify diffInSeconds ++ " ago"


agoify : Int -> String
agoify diff =
    if diff < 30 then
        "moments"

    else if diff < 2 * minute then
        "a minute"

    else if diff < 15 * minute then
        "a few minutes"

    else if diff < 45 * minute then
        "half an hour"

    else if diff < 60 * minute then
        "almost an hour"

    else if diff < 2 * hour then
        "an hour"

    else if diff < 9 * hour then
        "a few hours"

    else if diff < 18 * hour then
        "half a day"

    else if diff < 2 * day then
        "a day"

    else if diff < 5 * day then
        "a few days"

    else if diff < week then
        "almost a week"

    else if diff < 2 * week then
        "a week"

    else if diff < 3 * week then
        "a few weeks"

    else if diff < month then
        "almost a month"

    else if diff < 2 * month then
        "a month"

    else if diff < 9 * month then
        "months ago"

    else if diff < year then
        "almost a year"

    else if diff < 2 * year then
        "a year"

    else if diff < 8 * year then
        "a few years"

    else
        "A long time ago"
