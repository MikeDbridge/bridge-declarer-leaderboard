# wesbridge.net

Static site served by Cloudflare from this repo.

- **/** → redirects to **/wesdeal/** (the default landing).
- **/wesdeal/** → the WesBridge app (WesDeal deal generator, plus WesOdds / WesLab /
  WesBids / WesCal). Built from the WesDeal project (Vite, `base: './'`).
- **/wc/** → World-Championship four-facet card-play leaderboards (declarer & defender,
  2025 Herning + 2023 Marrakech). Kept available; not the default landing.

The `/wc/` pages are generated from the WBF microsite data; `/wesdeal/` is a copy of the
WesDeal app's `dist/`. Everything is static, no build on the host.
