module Slides where

allSlides = 
  [ """
# Elm Copenhagen
Wedensday November 25. at BestBrains
"""
  , """
## Program
- 18.00 - 19.00: Signals
- 19.00 - 20.30: Yatzy Dice Roller, group work and solution sharing
- 20.45 - 21.00: Demos
"""
  , """
## Step 1
Create the "static" view
```elm
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element as Element

someShape =
  ngon 3 50.0
    |> filled red
    |> move (20.0, -10.0)
    |> scale 2.5
    |> rotate (degrees 45)
    |> alpha 0.8

view = 
  collage 500 500 [ someShape ]
  
main = view
```
"""
  , """
## Step 2
Refactor `view` and `someShape` to take a single `Float` as a parameter
```elm
someShape x =
  ...

view x =
  ...

main = 
  view ??
```
- `Int -> Float` using `toFloat`
- `Float -> Int` using `round`/`floor`/`ceiling`/`truncate`
"""
  , """
## Step 3
Apply a Signal
```elm
import Mouse
import Signal
...

main = 
  Signal.map view Mouse.x
```
- adapt `view` to take Int as input
"""
  , """
## Step 4
Apply a Signal
```elm

main = 
  Signal.map view Mouse.x
```
- adapt `view` to take Int as input
"""
  , """
## Step 4
Apply another Signal
```elm
import Time
...
adapt x =
  Time.inSeconds x |> (*) 30

main = 
  Signal.map (adapt >> view) (Time.every Time.second)
```
- create intermediary functions to transform the incoming Signal Type and range to something that matches your parameter
"""
  , """
## Reactive in Elm
The Signal type represents values that can change over time
![Elm](assets/reactive-elm-diagram-small.png)
"""
  , """
## Doc links
- [Syntax](http://elm-lang.org/docs/syntax)
- [Style guide](http://elm-lang.org/docs/styleguide)
- [Docs for core libraries](http://package.elm-lang.org/)
"""
  , """
# Signals in core
- [Keyboard](http://package.elm-lang.org/packages/elm-lang/core/2.1.0/Mouse)
- [Mouse](http://package.elm-lang.org/packages/elm-lang/core/2.1.0/Mouse)
- [Time](http://package.elm-lang.org/packages/elm-lang/core/2.1.0/Time)
- [Touch](http://package.elm-lang.org/packages/elm-lang/core/2.1.0/Touch)
- [Window](http://package.elm-lang.org/packages/elm-lang/core/2.1.0/Window)

"""
  , """
# Signal manipulation
[Signal](http://package.elm-lang.org/packages/elm-lang/core/2.1.0/Signal)
- map, map2, map3 ...
- merge, mergeMany
- foldp
- filter, dropRepeats, sampleOn

[Signal Extra](http://package.elm-lang.org/packages/Apanatshka/elm-signal-extra/5.6.0)
"""
  ]
