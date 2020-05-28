module AtomicModel.Bohr exposing (view)

import Playground exposing (..)
import Util exposing (Size)



-- VIEW


view : Size -> Time -> List Shape
view size time =
    [ -- rings (largest to smallest)
      electronLevel size time size 5
    , electronLevel size time (size * 0.45) 2.25
    , electronLevel size time (size * 0.2) 1

    -- "nucleus"?
    , circle (rgb 243 162 162) (size * 0.05)

    -- labels
    , group
        [ nucleusLabel size
        , electronLabel size
        ]
        |> moveDown (size * 1.1)
        |> scale 0.7
    ]


electronLevel : Size -> Time -> Number -> Number -> Shape
electronLevel size time radius period =
    group
        [ ring lightPurple (2 * radius) (2 * radius) (size * 0.02)

        -- electron
        , group
            [ circle white (size * 0.06)
            , circle lightBlue (size * 0.05)
            ]
            |> moveUp (sin (degrees <| spin period time) * radius)
            |> moveLeft (cos (degrees <| spin period time) * radius)
        ]


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
