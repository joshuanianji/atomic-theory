module AtomicModel.Rutherford exposing (view)

import Playground exposing (..)
import Util exposing (Size)


view : Bool -> Size -> Time -> List Shape
view showLabel size time =
    [ -- standard rings
      orbital size time 0 0
    , orbital size time 1 60
    , orbital size time 2 120

    -- nucleus
    , circle (rgb 243 162 162) (size * 0.05)
    , if showLabel then
        group
            [ nucleusLabel size
            , electronLabel size
            ]
            |> moveDown (size * 1.1)
            |> scale 0.7

      else
        group []
    ]


orbital : Size -> Time -> Number -> Number -> Shape
orbital size time offset deg =
    group
        [ ring lightPurple (size * 0.7) (size * 2) (size * 0.02)

        -- electron
        , group
            [ circle white (size * 0.06)
            , circle lightBlue (size * 0.05)
            ]
            |> moveUp (sin (degrees <| spin 3 (delay offset time)) * size)
            |> moveLeft (cos (degrees <| spin 3 (delay offset time)) * (size * 0.35))
        ]
        |> rotate deg


nucleusLabel : Size -> Shape
nucleusLabel size =
    group
        [ circle (rgb 243 162 162) (size * 0.05)
            |> moveLeft (size * 0.5)
        , words black "Positively charged nucleus" False
            |> moveRight (size * 0.495)
        ]


electronLabel : Size -> Shape
electronLabel size =
    group
        [ circle lightBlue (size * 0.05)
            |> moveLeft (size * 0.5)
        , words black "Electron (charge: -1e)" False
            |> moveRight (size * 0.35)
        ]
        |> moveDown (size * 0.15)
