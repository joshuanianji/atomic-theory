module AtomicModel.Broglie exposing (view)

import Playground exposing (..)
import Util exposing (Center, Size)



-- VIEW


view : Size -> Time -> List Shape
view size time =
    [ -- rings (largest to smallest)
      electronLevel time size
    , electronLevel time (size * 0.45)
    , electronLevel time (size * 0.2)

    -- "nucleus"?
    , nucleus size

    -- labels
    , group
        [ nucleusLabel size
        , protonLabel size
        , electronWaveLabel time size
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


electronLevel : Time -> Number -> Shape
electronLevel time radius =
    group
        [ ring lightPurple (2 * radius + wave -3 3 4 time) (2 * radius + wave 3 -3 4 time) 2
            |> rotate (spin 6 time)
        , ring lightPurple (2 * radius + wave 3 -3 4 time) (2 * radius + wave -3 3 4 time) 2
            |> rotate (spin 6 time)
        , ring lightBlue (2 * radius) (2 * radius) 2
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


electronWaveLabel : Time -> Size -> Shape
electronWaveLabel time size =
    let
        wave =
            group
                [ sinWave time size 20
                , rectangle lightPurple (size * 0.4) (size * 0.02)
                ]
                |> moveLeft (size * 0.5)
    in
    group
        [ wave
        , words black "Electron Wave (charge: -1e)" False
            |> moveRight (size * 0.505)
        ]
        |> moveDown (size * 0.3)



-- a bunch of dots to draw out the sin wave for the electron wave label
-- we can control the amount of points


sinWave : Time -> Size -> Int -> Shape
sinWave time size density =
    let
        wavePoint =
            circle lightBlue (size * 0.01)

        -- coords of all the points
        coords =
            List.repeat (density + 1) ( 0, 0 )
                |> List.indexedMap
                    -- spreads coordinates around the line and makes it a sin wave (trust me the math works :"))
                    (\n _ -> ( toFloat n * size * 0.4 / toFloat density - size * 0.2, (*) 4 <| sin <| toFloat n * 2 * pi / toFloat density ))
    in
    List.map2
        (\( x1, y1 ) ( x2, y2 ) ->
            let
                wavey1 =
                    wave -y1 y1 3 time

                wavey2 =
                    wave -y2 y2 3 time
            in
            [ wavePoint
                |> moveX x1
                |> moveY wavey1
            , rectangleConnector (size * 0.01) lightBlue ( x1, wavey1 ) ( x2, wavey2 )
            ]
        )
        coords
        (List.drop 1 coords ++ List.drop (density - 1) coords)
        |> List.concat
        |> group



-- draws a rectangle to connect two points


rectangleConnector : Float -> Color -> Center -> Center -> Shape
rectangleConnector thiqueness color ( x2, y2 ) ( x1, y1 ) =
    let
        deltaX =
            x2 - x1

        deltaY =
            y2 - y1

        length =
            sqrt <| deltaX ^ 2 + deltaY ^ 2

        avgX =
            (x2 + x1) / 2

        avgY =
            (y2 + y1) / 2

        degree =
            atan2 deltaY deltaX
                |> fromRadians
    in
    Playground.rectangle color length (thiqueness * 2)
        |> Playground.moveX avgX
        |> Playground.moveY avgY
        |> Playground.rotate degree



--convert radians to degree


fromRadians : Float -> Float
fromRadians r =
    r * 180 / pi
