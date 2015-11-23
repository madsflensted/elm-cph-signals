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
Create something to view
```elm
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (show)

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
Refactor `view` and `someShape` to take a single `Float` as a parameter. Use the parameter to control one of the facets of your shape.
```elm
someShape : Float -> Form
someShape x =
  ...

view x =
  ...

main = 
  view ...
```
Experiment with changing the value passed to `view`
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
Adapt `view` to transform the Int type in Mouse.x to type of Float

Number conversion:
- `Int -> Float`, use `toFloat`
- `Float -> Int`, use `round`/`floor`/`ceiling`/`truncate`

What about range and scale of input parameter?
What happens if you use the parameter to control multiple facets of your shape?
"""
  , """
## Side note: Graphics with Elm Collage and Mouse
- `Mouse` values have (0,0) in upper left corner - growing (right, down)
- `Collage` has (0,0) in the middle - growing (right, up). I.e. the [Cartesian coordinate system](https://en.wikipedia.org/wiki/Cartesian_coordinate_system)

Convert Mouse coordinates to Cartesian:
```elm
cartesianX : Int -> Int -> Float
cartesianX x width =
  x - (width // 2) |> toFloat

cartesianY : Int -> Int -> Float
cartesianY y height =
  (height // 2) - y |> toFloat

cartesian : (Int, Int) -> (Int, Int) -> (Float, Float)
cartesian (x, y) (width, height) =
  (cartesianX x width, cartesianY y height)

```
"""
  , """
## Step 4
Apply another Signal
```elm

view x y =
  ...

main = 
  Signal.map2 view Mouse.x Mouse.y
```
Signal.map is defined for up to 5 signals
"""
  , """
## Side note: Standard Library Signal sources
- [Keyboard](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Mouse)
- [Mouse](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Mouse)
- [Time](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Time)
- [Touch](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Touch)
- [Window](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Window)
"""
  , """
## Step 5
Remember the past
```elm
cartesianX x width =
    x - (width // 2)

update x acc =
    (cartesianX x 500) + acc

historyX = Signal.foldp update 0 Mouse.x

main = Signal.map view historyX
```

"""
  , """
## Step 6
Merge
```elm
```

"""
  , """
## Time
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
## What we can know about a Signal
- a Signal wraps value that changes over time
- a Signal value has a predefined type
- a Signal value is always defined
- a Signal value cannot be inspected
- a Signal value can be transformed using pure functions
- a Signal must be defined at compile time
- to be usefull the Signal must be passed to `main` or to a `port`
"""
  , """
## Doc links
- [Syntax](http://elm-lang.org/docs/syntax)
- [Style guide](http://elm-lang.org/docs/styleguide)
- [Docs for core libraries](http://package.elm-lang.org/)
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
