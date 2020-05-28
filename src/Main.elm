module Main exposing (main)

import AtomicModel.Rutherford as Rutherford
import Browser
import Descriptions exposing (Description)
import Dialog
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Html exposing (Html)
import Icons
import Keyboard exposing (Key(..))
import Playground
import Scientist exposing (Scientist(..))
import Util



-- APPLICATION


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { page : Page
    , showDialog : Bool -- thingy from the help button
    , animation : Playground.Animation -- Animation for elm-playground
    , pressedKeys : List Key -- temporary for me to jump to things
    , deviceClass : Element.DeviceClass
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { page = Home
      , showDialog = False
      , animation = Playground.initAnimation
      , pressedKeys = []
      , deviceClass = .class <| Element.classifyDevice flags
      }
    , Cmd.none
    )


type alias Flags =
    { width : Int
    , height : Int
    }



-- each scientist has its own page, holding their corresponding description


type Page
    = Home
    | Scientist Scientist



-- VIEW


view : Model -> Html Msg
view model =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        ]
        [ content model
        , timeline model
        ]
        |> Element.layout
            [ Font.family [ Font.typeface "Playfair Display", Font.serif ]
            , Element.inFront <| helpPopup model
            ]


content : Model -> Element Msg
content model =
    case model.page of
        Scientist scientist ->
            viewScientist scientist model

        Home ->
            Element.column
                [ Element.width Element.fill
                , Element.height Element.fill
                , Element.padding 48
                , Element.behindContent
                    (Playground.viewAnimation model.animation (Rutherford.view False 125)
                        |> Element.html
                        |> Element.el
                            [ Element.height Element.fill
                            , Element.width (Element.fill |> Element.maximum 500)
                            , Element.alignRight
                            ]
                        |> Element.map PlaygroundMsg
                    )
                ]
                [ -- scientific investogator
                  Element.paragraph
                    [ Font.size 48
                    , Element.width Element.shrink
                    , Background.color <| Element.rgb 1 1 1
                    , Element.centerX
                    ]
                    [ Element.text "THE SCIENTIFIC "
                    , Element.el [ Font.color Util.lightBlue ] <| Element.text "NG"
                    , Element.text "VESTIGATOR"
                    ]

                -- title
                , Element.column
                    [ Element.width Element.fill
                    , Element.spacing 24
                    , Element.centerY

                    -- putting the help circle below the title to ensure the title stays in the center
                    , Element.below <|
                        Element.el
                            [ Element.paddingXY 0 64
                            , Element.width Element.fill
                            ]
                        <|
                            Element.el
                                [ Element.centerX
                                , Element.centerY
                                , Element.paddingXY 0 24
                                , Element.pointer
                                , Font.color Util.lightBlue
                                , Element.mouseOver
                                    [ Font.color Util.lightPurple ]
                                , Events.onClick OpenDialog
                                ]
                                (Element.html Icons.helpCircle)
                    ]
                    [ Element.paragraph
                        [ Font.size 36
                        , Element.width Element.shrink
                        , Background.color <| Element.rgb 1 1 1
                        ]
                        [ Element.text "A Short History of" ]
                    , Element.paragraph
                        [ Font.size 72
                        , Element.width Element.shrink
                        , Background.color <| Element.rgb 1 1 1
                        ]
                        [ Element.text "THE ATOMIC MODEL" ]
                    ]

                -- date and stuff
                , Element.row
                    [ Element.centerX
                    , Element.spacing 16
                    ]
                    [ Element.row
                        [ Font.italic
                        , Element.width Element.fill
                        ]
                        [ Element.text "Curated by "

                        -- link to my github lol
                        , Element.newTabLink
                            [ Element.mouseOver
                                [ Font.color Util.lightGray ]
                            , Font.underline
                            ]
                            { url = "https://github.com/joshuanianji"
                            , label = Element.text "Joshua Ji"
                            }
                        ]
                    , Element.text "|"
                    , Element.paragraph
                        []
                        [ Element.text "May 2020" ]
                    ]
                ]
                |> Util.responsiveSurround model.deviceClass


viewScientist : Scientist -> Model -> Element Msg
viewScientist scientist model =
    case Scientist.getAtomAndDescription scientist of
        ( Nothing, description ) ->
            viewDescription description
                |> Util.surround 1 2 1

        ( Just viewAtom, description ) ->
            Element.row
                [ Element.width Element.fill
                , Element.height Element.fill
                ]
                [ Playground.viewAnimation model.animation (viewAtom 100)
                    |> Element.html
                    |> Element.el
                        [ Element.width Element.fill
                        , Element.height Element.fill
                        ]
                    |> Element.map PlaygroundMsg
                , viewDescription description
                ]


viewDescription : Description -> Element Msg
viewDescription desc =
    let
        footnote =
            case desc.note of
                Nothing ->
                    Element.none

                Just note ->
                    Element.paragraph
                        [ Element.alignBottom
                        , Font.size 20
                        , Element.onLeft <|
                            Element.el
                                [ Element.centerY
                                , Element.paddingXY 16 2
                                , Font.size 24
                                ]
                            <|
                                Element.text "**"
                        ]
                        [ Element.text note ]
    in
    Element.el
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.padding 48
        , Element.behindContent <|
            Element.el
                [ Element.width Element.fill
                , Element.height Element.fill
                , Element.padding 48
                ]
                footnote
        ]
    <|
        Element.column
            [ Element.centerY
            , Element.width Element.fill
            , Element.spacing 16
            ]
            [ Element.paragraph
                [ Font.size 24, Font.italic, Font.color (Element.rgb 0.3 0.3 0.3) ]
                [ Element.text <| String.fromInt desc.date ]
            , Element.paragraph
                [ Font.size 48 ]
                [ Element.text desc.name ]
            , Element.paragraph
                [ Font.size 24
                , Element.spacing 8
                ]
                [ Element.text desc.description ]
            ]



-- thingy at the bottom
-- this code gives me migraines


timeline : Model -> Element Msg
timeline model =
    let
        currScientist =
            case model.page of
                Home ->
                    Nothing

                Scientist s ->
                    Just s

        iconWrapper msg disabled =
            let
                attributes =
                    if disabled then
                        [ Element.padding 16
                        , Font.color Util.lightGray
                        ]

                    else
                        [ Element.padding 16
                        , Element.pointer
                        , Events.onClick msg
                        ]
            in
            Element.html >> Element.el attributes

        viewTimelineScientist scientist =
            let
                underlineObject =
                    Element.el
                        [ Background.color Util.lightBlue
                        , Element.width Element.fill
                        , Element.height <|
                            case model.page of
                                Scientist s ->
                                    if s == scientist then
                                        Element.px 5

                                    else
                                        Element.px 0

                                _ ->
                                    Element.px 0
                        ]
                        Element.none
                        |> Element.el
                            [ Element.alignBottom
                            , Element.width Element.fill
                            ]
            in
            Element.paragraph
                [ Element.width Element.shrink
                , Element.centerY
                , Element.centerX
                , Element.behindContent underlineObject
                , Element.padding 4
                , Font.center
                , Font.size 18
                , Util.unselectable
                ]
                [ Element.text <| Scientist.toString scientist
                ]
                |> Element.el
                    [ Element.width Element.fill
                    , Element.pointer
                    , Element.mouseOver
                        [ Font.color Util.lightGray ]
                    , Events.onClick (JumpTo scientist)
                    ]
    in
    Element.row
        [ Element.padding 12
        , Element.width Element.fill
        ]
        [ -- left icon
          iconWrapper PreviousPage (currScientist == Nothing) Icons.chevronLeft
        , Element.row
            [ Element.width Element.fill ]
          <|
            List.map viewTimelineScientist Scientist.list

        -- right icon
        , iconWrapper NextPage (Maybe.map Scientist.isLast currScientist == Just True) Icons.chevronRight
        ]


helpPopup : Model -> Element Msg
helpPopup model =
    let
        header =
            Element.text "Quick Info"

        body =
            Element.textColumn
                [ Element.spacing 8 ]
                [ Element.paragraph
                    []
                    [ Element.text "To navigate left and right, use the "
                    , Element.el [ Font.bold ] <| Element.text "arrow keys"
                    , Element.text " or "
                    , Element.el [ Font.bold ] <| Element.text "click"
                    , Element.text " the arrows at the bottom."
                    ]
                , Element.paragraph
                    []
                    [ Element.el [ Font.bold ] <| Element.text "Click"
                    , Element.text " on any scientist to jump to that scientist's page."
                    ]
                ]

        footer =
            Element.el
                [ Element.centerX
                , Element.centerY
                , Element.pointer
                , Font.color Util.lightBlue
                , Element.mouseOver
                    [ Font.color Util.lightPurple ]
                , Events.onClick CloseDialog
                ]
                (Element.html Icons.xCircle)

        config =
            { closeMessage = Nothing
            , maskAttributes = []
            , containerAttributes =
                [ Element.spacing 32
                , Element.centerX
                , Element.centerY
                , Element.width (Element.px 600)
                , Background.color <| Element.rgb 1 1 1
                , Element.padding 32
                , Border.rounded 8
                ]
            , headerAttributes =
                [ Font.bold
                , Font.size 32
                , Element.width Element.fill
                ]
            , bodyAttributes = []
            , footerAttributes = [ Element.width Element.fill ]
            , header = Just header
            , body = Just body
            , footer = Just footer
            }

        dialogConfig =
            if model.showDialog then
                Just config

            else
                Nothing
    in
    Dialog.view dialogConfig



-- UPDATE


type Msg
    = PreviousPage
    | NextPage
    | JumpTo Scientist
    | OpenDialog
    | CloseDialog
    | PlaygroundMsg Playground.Msg
    | KeyMsg Keyboard.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( PlaygroundMsg playgroundMsg, _ ) ->
            ( { model | animation = Playground.updateAnimation playgroundMsg model.animation }
            , Cmd.none
            )

        ( PreviousPage, Scientist s ) ->
            let
                newPage =
                    if Scientist.isFirst s then
                        Home

                    else
                        Scientist <| Scientist.previousScientist s
            in
            ( { model | page = newPage }
            , Cmd.none
            )

        ( NextPage, Home ) ->
            ( { model | page = Scientist Scientist.first }
            , Cmd.none
            )

        ( NextPage, Scientist s ) ->
            ( { model | page = Scientist <| Scientist.nextScientist s }
            , Cmd.none
            )

        ( JumpTo s, _ ) ->
            ( { model | page = Scientist s }
            , Cmd.none
            )

        ( OpenDialog, Home ) ->
            ( { model | showDialog = True }
            , Cmd.none
            )

        ( CloseDialog, _ ) ->
            ( { model | showDialog = False }
            , Cmd.none
            )

        ( KeyMsg keyMsg, _ ) ->
            let
                newKeys =
                    Keyboard.update keyMsg model.pressedKeys

                -- binding the keyboard jumps to actions (such as moving to the next page)
                actions =
                    [ ( Keyboard.ArrowRight, NextPage )
                    , ( Keyboard.ArrowLeft, PreviousPage )
                    ]

                maybeNextMsgs =
                    List.filterMap
                        (\( key, message ) ->
                            if List.member key newKeys then
                                Just message

                            else
                                Nothing
                        )
                        actions

                newModel =
                    { model | pressedKeys = newKeys }
            in
            case maybeNextMsgs of
                newMsg :: _ ->
                    update newMsg newModel

                [] ->
                    ( newModel, Cmd.none )

        -- ignore message
        ( _, _ ) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map PlaygroundMsg (Playground.subscriptionsAnimation model.animation)
        , Sub.map KeyMsg Keyboard.subscriptions
        ]
