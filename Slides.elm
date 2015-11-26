module Slides where

allSlides = 
  [ """
# Elm Copenhagen
Wedensday November 25. at BestBrains

##### https://madsflensted.github.io/elm-cph-signals
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
    |> alpha 0.8
    |> scale 2.5
    |> move (20.0, -10.0)
    |> rotate (degrees 45)

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
NOTE: above works because our example has the collage's upper left corner at absolute position (0,0) on the web page, otherwise you would need to add that position to get the correct result.
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
- Extract another parameter in `someShape` and use Mouse.y to control that

Signal.map is defined for up to 5 signals
"""
  , """
## Side note: Signals in the Standard Library
- [Keyboard](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Mouse)
- [Mouse](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Mouse)
- [Time](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Time)
- [Touch](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Touch)
- [Window](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Window)
"""
  , """
## Step 5
Use past Signal values with `foldp`

![Elm](assets/signal-map-foldp.png)

```
foldp : (a -> b -> b) -> b -> Signal a -> Signal b
```
"""
  , """
## Step 6
Count clicks
```elm
update action count =
  count + 1

model = 
  Signal.foldp update 0 Mouse.clicks

main = Signal.map show model
```

"""
  , """
## Step 7
Merge two Signals
```elm
type Action = PosX Int | Click

update action (pos, count) =
  case action of
    PosX x -> (x, count)
    Click -> (pos, count + 1)

inputs = 
  Signal.mergeMany
    [ Signal.map PosX Mouse.x
    , Signal.map (\\_ -> Click) Mouse.clicks
    ]

model = 
  Signal.foldp update (0, 0) inputs

main = Signal.map show model
```
"""
  , """
## Step 8
Filtering Signals
```elm
update action count =
  case action of
    False -> count
    True -> count + 1

inputs = 
    Signal.sampleOn Mouse.clicks (Keyboard.isDown 32)

model = 
  Signal.foldp update 0 inputs 

main = Signal.map show model
```
- Give step 6, 7 and 8 a try
- Use `foldp`, `mergeMany` to manipulate your `someShape` with different inputs

"""
  , """
## What we know about a Signal
- a Signal wraps value that changes over time
- a Signal value has a predefined type
- a Signal value is always defined
- a Signal value cannot be inspected
- a Signal value can be transformed using pure functions
- a Signal must be defined at compile time
- to be usefull the Signal must be passed to `main` or to a `port`
"""
  , """
## Reactive in Elm
The Signal type represents values that can change over time
![Elm](assets/reactive-elm-diagram-small.png)
"""
  , """
## Connect Four
![Connect Four Game](assets/connect-four-small.jpg)
- Make [Last Months](ConnectFour.elm) playable
- [Playable version](https://raw.githubusercontent.com/madsflensted/connect-four/master/ConnectFour.elm)
"""
  , """
## Examples, Dot clock
```elm
import Color exposing (rgb, black)
import Graphics.Collage exposing (..)
import Signal
import Time exposing (inSeconds, every, millisecond)

main =
    Signal.map (dot << inSeconds) (every <| 10 * millisecond)

dot t =
  let x = 75*cos(-2*pi * t / 60)
      y = 75*sin(-2*pi * t / 60)
  in collage 200 200
      [ circle 2 |> filled (rgb 128 0 128) |> move (x, y) 
      , square 200 |> outlined (solid black)
      ]
```
- Try it out

By [Joey Eremondi](http://codegolf.stackexchange.com/questions/62095/a-single-pixel-moving-in-a-circular-path/62189#62189)
"""
  , """
## Examples, Running Lambda
```elm
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Text
import Color exposing (..)
import Time
import Signal

lambdaForm scaleFactor color pos =
    Text.fromString "𝝀"
      |> Text.color color
      |> text
      |> scale scaleFactor
      |> move pos
                      
colors =
  [purple, blue, green, yellow, orange, red]
  |> List.map (List.repeat 12)
  |> List.concat

animatedColors =
  let step _ colorLists =
    case colorLists of
      (color::colors)::_ -> (colors ++ [color]) :: colorLists
      [] :: _ -> []
      [] -> []
  in
    List.foldr step [colors] colors
      |> List.map (\\xs -> xs ++ [lightOrange])
      |> List.reverse
      |> List.indexedMap (\\i x -> if i % 2 == 0 then Just x else Nothing)
      |> List.filterMap identity

positions start diffX diffY =
  let step _ xs =
    case xs of
      (x,y) :: _ -> (x + diffX, y - diffY) :: xs
      [] -> []
  in
    List.foldr step [start] colors

model = animatedColors

update _ remainingFrames =
  case remainingFrames of
    [_] -> animatedColors
    [] -> animatedColors
    _::tl -> tl

view remainingFrames =
  let colors = remainingFrames |> List.head |> Maybe.withDefault []
  in
    (rect 400 400 |> filled lightGrey)
    :: List.map2 (lambdaForm 30) colors (positions (-62,90) 1.5 0.75)
      |> collage 400 400

main : Signal Element
main =
  Time.fps 24 |> Signal.foldp update model |> Signal.map view
```
- Try it out

By [James MacAuly](https://gist.github.com/jamesmacaulay/048ecc7b789524e84b37)
"""
  , """
# BREAK
"""
  , """
# Yatzy Dice Roller

Group Exercise

##### https://github.com/elmcph/yatzy-dice-roller
"""
  , """
# Next Meetup

January 27. 2016

"""
  ]
