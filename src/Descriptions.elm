module Descriptions exposing (Description, bohr, broglie, dalton, einstein, millikan, planck, rutherford, schrodinger, thomson)

-- a description talks about a scientist


type alias Description =
    { name : String
    , date : Int
    , description : String
    , note : Maybe String
    }


dalton : Description
dalton =
    { name = "John Dalton: Billiard Ball Model"
    , date = 1810
    , description = "Dalton proposes the atomic theory to explain chemical relationships. In it, he says that all matter is composed of atoms, which are indivisible and can combine in predictable ratios."
    , note = Nothing
    }


thomson : Description
thomson =
    { name = "J.J. Thomson: Plum Pudding Model"
    , date = 1897
    , description = "Thomson’s experiment of the Cathode Ray tube proves that all atoms contain tiny, negatively charged subatomic particles. This prompted the creation of the Plum Pudding model, claiming that the atom is a positive, uniformly-dense mass with negative charges embedded within it."
    , note = Nothing
    }


planck : Description
planck =
    { name = "Max Planck"
    , date = 1905
    , description = "Planck provides a solution to the UV catastrophe by suggesting that there is a minimum amount of energy that could be absorbed or emitted by objects, which he called quantum (pl. quanta). This marked the birth of quantum mechanics, paving the way for more sophisticated atomic models in the future."
    , note = Nothing
    }


einstein : Description
einstein =
    { name = "Albert Einstein"
    , date = 1905
    , description = "Einstein proposes that mass is another form of energy, the two related by his famous formula, E=mc^2. This explains why the total mass of a nucleus is less than the masses of its nucleons: mass is “lost” and converted to another form of energy when the nucleus is constructed."
    , note = Nothing
    }


millikan : Description
millikan =
    { name = "Robert Millikan"
    , date = 1909
    , description = "Millikan conducts an oil drop experiment, where he measures the charge of a single electron. This is now known as the elementary charge, e, and is one of the fundamental physical constants."
    , note = Nothing
    }


rutherford : Description
rutherford =
    { name = "Ernest Rutherford: Planetary Model"
    , date = 1914
    , description = "In order to test Thompson’s model, Rutherford conducts a gold scattering experiment by shooting alpha particles to a sheet of gold foil, expecting the particles to travel straight through the foil undetected. Instead, a few particles are deflected at a large angle, supporting a hypothesis of a small, positively charged nucleus at the center of an atom around which electrons orbit akin to planets around a sun."
    , note = Just "The proton would be proven by Rutherford in 1919, and the neutron by James Chadwick in 1932."
    }


bohr : Description
bohr =
    { name = "Niels Bohr: Orbital Levels"
    , date = 1915
    , description = "Bohr proposes that the orbits of the electrons are quantized, and each orbit corresponds to a particular energy level for the electron. This is able to explain the emission and absorption spectra for hydrogen, but not for more complex atoms, and the issue of electrons radiating EMR remained an issue."
    , note = Nothing
    }


broglie : Description
broglie =
    { name = "Louis De Broglie: Standing Wave Model"
    , date = 1923
    , description = "De Broglie suggests that matter could behave as waves, just as light waves could behave as particles. He then goes on to show that electrons are circular standing waves around a nucleus, and thus would not emit radiation."
    , note = Just "By this time, Rutherford had proven the existence of protons, but neutrons remained a theory."
    }


schrodinger : Description
schrodinger =
    { name = "Erwin Schrödinger: Quantum Mechanical Model"
    , date = 1926
    , description = "Schrödinger develops a system of wave mechanics based upon de Broglie’s matter waves, giving rise to the electron cloud. Here, one would not be able to deduce the position of an electron, but use equations that describe the probability of finding an electron at a certain position."
    , note = Nothing
    }
