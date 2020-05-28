module AtomicModel.Schrodinger exposing (view)

import Playground exposing (..)
import Util exposing (Size)


view : Size -> Time -> List Shape
view size time =
    [ -- background
      circle lightBlue size
        |> fade 0.2

    -- Electron cloud animations
    -- Every 2 seconds
    , circle lightPurple (size * 0.2)
        |> scale (spin 3 time * 4 / 360 + 1)
        |> fade (wave 0.5 0 3 time)

    -- nucleus
    , nucleus size

    -- labels
    , group
        [ nucleusLabel size
        , protonLabel size
        , eCloudLabel time size
        ]
        |> moveDown (size * 1.1)
        |> scale 0.7
    ]



-- a hexagonal nucleus


nucleus : Size -> Shape
nucleus size =
    let
        -- helper variables for the coordinates of the hexagon
        a =
            0.5 * size * 0.03

        b =
            sqrt 3 * size * 0.03 / 2

        c =
            size * 0.03

        softRed =
            rgb 243 162 162

        nucleonSize =
            size * 0.03
    in
    group
        [ circle softRed nucleonSize
            |> moveRight c
        , circle softRed nucleonSize
            |> moveRight a
            |> moveUp b
        , circle softRed nucleonSize
            |> moveLeft a
            |> moveUp b
        , circle softRed nucleonSize
            |> moveLeft c
        , circle softRed nucleonSize
            |> moveRight a
            |> moveDown b
        , circle softRed nucleonSize
            |> moveLeft a
            |> moveDown b
        , circle softRed nucleonSize
        ]


nucleusLabel : Size -> Shape
nucleusLabel size =
    group
        [ nucleus size
            |> moveLeft (size * 0.5)
        , words black "Nucleus" False
        ]


protonLabel : Size -> Shape
protonLabel size =
    group
        [ circle (rgb 243 162 162) (size * 0.03)
            |> moveLeft (size * 0.5)
        , words black "Proton (charge: +1e)" False
            |> moveRight (size * 0.32)
        ]
        |> moveDown (size * 0.15)


eCloudLabel : Time -> Size -> Shape
eCloudLabel time size =
    let
        cloudAnimation =
            group
                [ rectangle lightBlue (size * 0.4) (size * 0.15)
                    |> fade 0.2
                , rectangle lightPurple (size * 0.4) (size * 0.15)
                    |> fade (wave 0.5 0 3 time)
                ]
                |> moveLeft (size * 0.5)
    in
    group
        [ cloudAnimation
        , words black "Electron Cloud (charge: -1e)" False
            |> moveRight (size * 0.525)
        ]
        |> moveDown (size * 0.3)
