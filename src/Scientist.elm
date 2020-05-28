module Scientist exposing (..)

import AtomicModel.Bohr as Bohr
import AtomicModel.Broglie as Broglie
import AtomicModel.Dalton as Dalton
import AtomicModel.Rutherford as Rutherford
import AtomicModel.Schrodinger as Schrodinger
import AtomicModel.Thomson as Thomson
import Descriptions exposing (Description)
import Playground exposing (Shape, Time)
import Util exposing (Size)


type Scientist
    = Dalton
    | Thomson
    | Planck
    | Einstein
    | Millikan
    | Rutherford
    | Bohr
    | Broglie
    | Schrodinger


list : List Scientist
list =
    [ Dalton
    , Thomson
    , Planck
    , Einstein
    , Millikan
    , Rutherford
    , Bohr
    , Broglie
    , Schrodinger
    ]


getAtomAndDescription : Scientist -> ( Maybe (Size -> Time -> List Shape), Description )
getAtomAndDescription scientist =
    case scientist of
        Dalton ->
            ( Just Dalton.view, Descriptions.dalton )

        Thomson ->
            ( Just Thomson.view, Descriptions.thomson )

        Planck ->
            ( Nothing, Descriptions.planck )

        Einstein ->
            ( Nothing, Descriptions.einstein )

        Millikan ->
            ( Nothing, Descriptions.millikan )

        Rutherford ->
            ( Just <| Rutherford.view True, Descriptions.rutherford )

        Bohr ->
            ( Just Bohr.view, Descriptions.bohr )

        Broglie ->
            ( Just Broglie.view, Descriptions.broglie )

        Schrodinger ->
            ( Just Schrodinger.view, Descriptions.schrodinger )


getAtom : Scientist -> Maybe (Size -> Time -> List Shape)
getAtom =
    getAtomAndDescription >> Tuple.first



-- HELPER FUNCTIONS
-- for things such as comparing, finding if it is the last scientist, etc.


isLast : Scientist -> Bool
isLast s =
    case s of
        Schrodinger ->
            True

        _ ->
            False


isFirst : Scientist -> Bool
isFirst s =
    case s of
        Dalton ->
            True

        _ ->
            False


first : Scientist
first =
    Dalton


nextScientist : Scientist -> Scientist
nextScientist s =
    case s of
        Dalton ->
            Thomson

        Thomson ->
            Planck

        Planck ->
            Einstein

        Einstein ->
            Millikan

        Millikan ->
            Rutherford

        Rutherford ->
            Bohr

        Bohr ->
            Broglie

        Broglie ->
            Schrodinger

        Schrodinger ->
            Schrodinger


previousScientist : Scientist -> Scientist
previousScientist s =
    case s of
        Dalton ->
            Dalton

        Thomson ->
            Dalton

        Planck ->
            Thomson

        Einstein ->
            Planck

        Millikan ->
            Einstein

        Rutherford ->
            Millikan

        Bohr ->
            Rutherford

        Broglie ->
            Bohr

        Schrodinger ->
            Broglie


toString : Scientist -> String
toString s =
    case s of
        Dalton ->
            "Dalton"

        Thomson ->
            "Thomson"

        Planck ->
            "Planck"

        Einstein ->
            "Einstein"

        Millikan ->
            "Millikan"

        Rutherford ->
            "Rutherford"

        Bohr ->
            "Bohr"

        Broglie ->
            "de Broglie"

        Schrodinger ->
            "Schrödinger"
