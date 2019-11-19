# Nilm

An attempt for a reddit-look-a-like using Elixir and Elm, 2 functional programming languages.

To start the server:
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser and check the api routes in `/lib/nilm_web/views/router.ex`.

Elm code can be found in `frontend-elm` (readme unmodified) and started with command found there.

# Why?
This was a hackathon attempt where I tried cramming 2 languages in about 3 days. The results were severely less than what I wanted but it showed me that being extremely ambitious can sometimes bite me and I have very little to show for it.

Even though this project remains incomplete, it stands so I remember that not every goal can be achieved in a timely manner and to better estimate my goals.

As far as technical knowledge gained, I finally realized why CORS is used and my functional programming mind seems to have set it at least partially due to using both of these languages.

Frankly, I am embarassed of my code here because it shows how inexperienced and naive I was. That being said, I think transparency and having the code open is more important than my pride.
