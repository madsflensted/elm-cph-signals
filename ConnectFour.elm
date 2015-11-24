module ConnectFour where

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import List exposing (..)

-- Model
type Player = A | B

type Slot = Empty | Piece Player

type alias Column = List Slot

type alias Board = List Column

type alias Model = Board

maxColumn = 7
maxRow = 6
pieceSize = 90 -- px

emptyBoard =
  repeat maxColumn (repeat maxRow Empty)

-- View

view : Model -> Element
view model =
  flow right <| map viewColumn model

viewColumn column =
  flow down <| map viewSlot column

viewSlot slot =
  let pieceRadius = (pieceSize - 15) / 2
      pieceColor piece =
        case slot of
           Empty -> white
           Piece A -> blue
           Piece B -> red
  in collage pieceSize pieceSize
    [ circle pieceRadius |> filled (pieceColor slot)]
    |> color orange


-- Update
update : (Player, Int) -> Model -> Model
update move board =
  List.indexedMap (updateColumn move) board

updateColumn : (Player, Int) -> Int -> Column -> Column
updateColumn (player, inColumn) index column =
  if inColumn /= index then
    column
  else
    player `dropIn` column

dropIn : Player -> Column -> Column
dropIn player column =
    let (empty, nonEmpty) = List.partition ((==) Empty) column
        filled = 
          case empty of
            [] -> nonEmpty
            _  -> Piece player :: nonEmpty
        empties = repeat (maxRow - (length filled)) Empty
    in empties `append` filled

nextPlayer : Player -> Player
nextPlayer turn =
  case turn of
    A -> B
    B -> A

-- Signals

-- Main
testMoves = [(A, 3), (B, 3), (A, 0), (B, 2), (A, 2), (B, 3)]

main = view <| foldl update emptyBoard testMoves
