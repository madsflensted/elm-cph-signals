import Array exposing (fromList, get)
import Center
import Html exposing (div, a, text, span)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Graphics.Element exposing (..)
import List
import Maybe exposing (withDefault)
import StartApp
import Slides
import Keyboard
import Effects

main = app.html

(->>) f g a b = f a b |> g  
addNoneEffect model = (model, Effects.none)

app =
  StartApp.start { init = initialModel |> addNoneEffect, view = view, update = update ->> addNoneEffect, inputs = inputs }

initialModel = 
  { index = 0
  , slides = Slides.allSlides
  }


view address model =
  let currentSlide = 
      withDefault "" (get model.index <| fromList model.slides)
  in div []
      [ div [] [ div [ class "navigate", style [("position", "absolute"), ("top", "0px"), ("left", "0px"), ("width", "150px"), ("height", "300px")], onClick address Decrement ] [ div [ class "overlay" ] [ span [ class "arrow" ] [ text "<" ] ] ]
               , div [ class "navigate", style [("position", "absolute"), ("top", "0px"), ("right", "0px"), ("width", "150px"), ("height", "300px")], onClick address Increment ] [ div [ class "overlay" ] [ span [ class "arrow" ] [ text ">" ] ] ]
               ]
      , div [] [ Center.markdown "600px" currentSlide ]
      ]


type Action = Increment | Decrement | NoOp


update action model =
  case action of
    Increment -> { model | index = (model.index + 1) % List.length(model.slides) }
    Decrement -> { model | index = (model.index - 1) % List.length(model.slides) }
    NoOp -> model


interpretArrows arrows =
  case (arrows.x, arrows.y) of
    (-1,_) -> Decrement
    (1, _) -> Increment
    (_, 1) -> Decrement
    (_,-1) -> Increment
    _  -> NoOp

inputs =
  [ Signal.map interpretArrows Keyboard.arrows ]