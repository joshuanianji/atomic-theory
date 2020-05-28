module Util exposing (Center, Size, distance, lightBlue, lightGray, lightPurple, responsiveSurround, surround, unselectable)

import Element exposing (Element)
import Html.Attributes
import Playground exposing (..)



-- size of the viewport


type alias Size =
    Float


type alias Center =
    ( Float, Float )


distance : ( Number, Number ) -> ( Number, Number ) -> Number
distance ( x1, y1 ) ( x2, y2 ) =
    (x1 - x2)
        ^ 2
        + (y1 - y2)
        ^ 2
        |> sqrt



-- color


lightGray : Element.Color
lightGray =
    Element.rgb 0.7 0.7 0.7


lightBlue : Element.Color
lightBlue =
    Element.rgb255 114 159 207


lightPurple : Element.Color
lightPurple =
    Element.rgb255 173 127 168


responsiveSurround : Element.DeviceClass -> Element msg -> Element msg
responsiveSurround class =
    let
        ( left, middle, right ) =
            case class of
                Element.BigDesktop ->
                    ( 1, 2, 1 )

                Element.Desktop ->
                    ( 1, 3, 1 )

                _ ->
                    ( 0, 1, 0 )
    in
    \el ->
        Element.row
            [ Element.width Element.fill, Element.height Element.fill ]
            [ Element.el [ Element.width <| Element.fillPortion left, Element.height Element.fill ] Element.none
            , Element.el [ Element.width <| Element.fillPortion middle, Element.height Element.fill ] el
            , Element.el [ Element.width <| Element.fillPortion right, Element.height Element.fill ] Element.none
            ]


surround : Int -> Int -> Int -> Element msg -> Element msg
surround left middle right =
    \el ->
        Element.row
            [ Element.width Element.fill, Element.height Element.fill ]
            [ Element.el [ Element.width <| Element.fillPortion left, Element.height Element.fill ] Element.none
            , Element.el [ Element.width <| Element.fillPortion middle, Element.height Element.fill ] el
            , Element.el [ Element.width <| Element.fillPortion right, Element.height Element.fill ] Element.none
            ]


unselectable : Element.Attribute msg
unselectable =
    Element.htmlAttribute (Html.Attributes.style "user-select" "none")
