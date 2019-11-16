{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "pux"
, dependencies =
    [ "aff"
    , "affjax"
    , "console"
    , "css"
    , "effect"
    , "foreign-object"
    , "functions"
    , "globals"
    , "lists"
    , "ordered-collections"
    , "profunctor"
    , "psci-support"
    , "react"
    , "signal"
    , "smolder"
    , "test-unit"
    , "web-html"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
