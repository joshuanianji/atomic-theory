module AtomicModel.Dalton exposing (view)

import Playground exposing (..)
import Util exposing (Center, Size)


view : Size -> Time -> List Shape
view size _ =
    [ -- oxygen
      oxygen size ( -size * 0.66, size * 0.5 )
        |> labelAtom size "Oxygen" ( -size * 0.66, size * 0.5 )

    -- hydrogen
    , hydrogen size ( size * 0.66, size * 0.5 )
        |> labelAtom size "Hydrogen" ( size * 0.66, size * 0.5 )

    -- water
    , water size ( 0, -size * 0.75 )
        |> labelAtom size "Water molecule" ( 0, -size * 0.75 )
    ]


oxygen : Size -> Center -> Shape
oxygen size ( x, y ) =
    ring black (size * 0.5) (size * 0.5) (size * 0.02)
        |> moveX x
        |> moveY y


hydrogen : Size -> Center -> Shape
hydrogen size ( x, y ) =
    group
        [ ring black (size * 0.5) (size * 0.5) (size * 0.02)
        , circle black (size * 0.05)
        ]
        |> moveX x
        |> moveY y


water : Size -> Center -> Shape
water size ( x, y ) =
    group
        [ oxygen size ( -size * 0.25, 0 )
        , hydrogen size ( size * 0.25, 0 )
        ]
        |> moveX x
        |> moveY y


labelAtom : Size -> String -> Center -> Shape -> Shape
labelAtom size str ( x, y ) shape =
    group
        [ shape
        , words black str False
            |> moveDown (size * 0.4)
            |> moveX x
            |> moveY y
        ]
