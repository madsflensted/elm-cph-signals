import Array exposing (fromList, get)
import Center
import Html exposing (div, a, text, span)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Graphics.Element exposing (..)
import List
import Maybe exposing (withDefault)
import StartApp.Simple as StartApp
import Slides


main =
  StartApp.start { model = model, view = view, update = update }


model = 
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


type Action = Increment | Decrement


update action model =
  case action of
    Increment -> { model | index = (model.index + 1) % List.length(model.slides) }
    Decrement -> { model | index = (model.index - 1) % List.length(model.slides) }
