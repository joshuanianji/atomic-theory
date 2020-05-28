module AtomicModel.Thomson exposing (view)

-- Ugh this atomic model looks the ugliest

import Playground exposing (..)
import Util exposing (Center, Size)



-- scaled to a circle of radius 1


electronCoords : List Center
electronCoords =
    [ ( 0, 0.6 )
    , ( 0.6, 0.2 )
    , ( 0.37, -0.58 )
    , ( -0.37, -0.58 )
    , ( -0.58, 0.15 )
    ]


view : Size -> Time -> List Shape
view size _ =
    [ -- bread
      circle (rgb 243 162 162) size
        |> fade 0.7

    -- label for bread
    , words black "Positively charged mass" False
        |> moveUp (size * 1.25)
    , rectangle black (size * 0.35) (size * 0.01)
        |> rotate 110
        |> moveUp size
        |> moveLeft (size * 0.3)

    -- plums
    , electrons size lightBlue

    -- label for electron
    , words black "Negatively charged \"plum\"" False
        |> moveDown (size * 1.25)
    , rectangle black (size * 0.55) (size * 0.01)
        |> rotate 255
        |> moveDown (size * 0.9)
        |> moveRight (size * 0.3)
    ]


electrons : Size -> Color -> Shape
electrons size color =
    electronCoords
        |> List.map
            (\( x, y ) ->
                circle color (size * 0.1)
                    |> moveX (x * size)
                    |> moveY (y * size)
            )
        |> group
