Object subclass: Mission [
    | name finished startLocation |

    name: aName [
        name := aName
    ]

    finished: aBoolean [
        finished := aBoolean
    ]

    startLocation: aLocation [
        startLocation := aLocation
    ]

    name [
        ^ name
    ]

    finished [
        ^ finished
    ]

    startLocation [
        ^ startLocation
    ]

    asString [
        ^ name
    ]
].



Object subclass: Npc [
    | name message |

    name: aName [
        name := aName
    ]

    message: aMessage [
        message := aMessage
    ]

    name [
        ^ name
    ]

    message [
        ^ message
    ]

    asString [
        ^ name
    ]
].



Object subclass: Obtainable [
    | name finishing |

    name: aName [
        name := aName
    ]

    name [
        ^ name
    ]

    finishing [
        ^ finishing
    ]

    finishing: aBoolean [
        finishing := aBoolean
    ]

    initialize [
        finishing := false.
    ]

    asString [
        ^ name
    ]

    Obtainable class >> new [
        | instance |
        instance := super new.
        instance initialize.
        ^ instance
    ]
].



Object subclass: Searchable [
    | name content description |

    name: aName [
        name := aName
    ]

    description: aDescription [
        description := aDescription
    ]

    description [
        ^ description
    ]

    name [
        ^ name
    ]

    asString [
        ^ name
    ]

    content [
        ^ content
    ]

    content: aCollection [
        content := aCollection
    ]

    initialize [
        content := OrderedCollection new.
    ]

    addContent: anObtainable [
        content add: anObtainable
    ]

    removeThing: anObtainable [
        content remove: anObtainable ifAbsent: [].
    ]

    listObtainable [
        ^ content ifNil: [ #() ] ifNotNil: [ content asArray ].
    ]

    Searchable class >> new [
        | instance |
        instance := super new.
        instance initialize.
        ^ instance
    ]
].



Object subclass: Location [
    | name description searchable obtainable askable finishing |

    name: aString [
        name := aString
    ]

    name [
        ^ name
    ]

    description: newDesc [
        description := newDesc
    ]

    description [
        ^ description
    ]

    finishing [
        ^ finishing
    ]

    finishing: aBoolean [
        finishing := aBoolean
    ]

    searchable [
        ^ searchable
    ]

    searchable: aCollection [
        searchable := aCollection
    ]

    obtainable [
        ^ obtainable
    ]

    obtainable: aCollection [
        obtainable := aCollection
    ]

    askable [
        ^ askable
    ]

    askable: aCollection [
        askable := aCollection
    ]

    initialize [
        obtainable := OrderedCollection new.
        askable := OrderedCollection new.
        searchable := OrderedCollection new.
        finishing := false
    ]

    addSearchable: aSearchable [
        searchable add: aSearchable
    ]

    removeSearchable: aSearchable [
        searchable remove: aSearchable ifAbsent: [].
    ]

    listSearchable [
        ^ searchable ifNil: [ #() ] ifNotNil: [ searchable asArray ].
    ]

    addThing: anObtainable [
        obtainable add: anObtainable
    ]

    removeThing: anObtainable [
        obtainable remove: anObtainable ifAbsent: [].
    ]

    listObtainable [
        ^ obtainable ifNil: [ #() ] ifNotNil: [ obtainable asArray ].
    ]

    listAskable [
        ^ askable ifNil: [ #() ] ifNotNil: [ askable asArray ].
    ]

    addAskable: anNpc [
        askable add: anNpc
    ]

    Location class >> new [
        | instance |
        instance := super new.
        instance initialize.
        ^ instance
    ]
].



Object subclass: LocationsConnection [
    | currentLocation newLocation |

    currentLocation: aLocation [
        currentLocation := aLocation
    ]

    currentLocation [
        ^ currentLocation
    ]

    newLocation: aLocation [
        newLocation := aLocation
    ]

    newLocation [
        ^ newLocation
    ]
].



LocationsConnection subclass: LocationsStandardConnection [
    | direction |

    direction: aDirection [
        direction := aDirection
    ]

    direction [
        ^ direction
    ]
].


LocationsConnection subclass: LocationsPasswordConnection [
    | password middle |

    password: aPassword [
        password := aPassword
    ]

    password [
        ^ password
    ]

    middle: aSearchable [
        middle := aSearchable
    ]

    middle [
        ^ middle
    ]
].



Object subclass: Game [
    |

        "Mission progress."
        drill_mission
        car_mission
        weapon_mission


        "Obtainable."
        drill
        barrow
        beams
        hammers
        windows

        axe
        crowbar
        porsche_keys
        bmw_keys
        jeep_keys


        "Searchable"
        blue_container
        white_container
        black_container
        red_container
        yellow_container
        green_container

        neighbourhood
        envelope
        gate
        porsche
        bmw
        jeep
        shelf
        first_drawer
        second_drawer
        third_drawer
        fourth_drawer
        fifth_drawer


        "Places"
        lobby
        construction_site_south_gate
        construction_site
        containers
        construction_site_east_gate

        vinewood_hills
        mansion_frontyard
        outbuilding


        "Places connections."
        construction_site_south_gate_N_construction_site
        construction_site_S_construction_site_south_gate
        construction_site_E_containers
        containers_W_construction_site
        containers_E_construction_site_east_gate
        construction_site_east_gate_W_containers

        vinewood_hills_black20_mansion_frontyard
        mansion_frontyard_E_outbuilding
        outbuilding_W_mansion_frontyard


        "NPCs"
        worker
        supervisor


        "Game state."
        isGameOver
        current_mission
        location
        has

    |

    introductionText := #(
        'You are about to rob the biggest bank of Los Santos.'
        'You have to be well prepared.'
        'You need a solid drill, fast car and a weapon.'
        'You need to get them before robbery.'
        'Choose first mission - getting drill, car or weapon.'
    ).

    instructionsText := #(
        'Available commands are:'
        ''
        'n,  s,  e,  w              -- to go in that direction.'
        'choose_mission *mission*    -- to start mission (options: car, drill, weapon).'
        'finish_mission             -- to finish mission (after completing required tasks - getting car keys or drill or type of weapon).'
        'take *object*              -- to pick up an object.'
        'drop                       -- to put down an object.'
        'open(Thing, Tool/Code)     -- to open a secured (probably closed) Thing (can be gate, window or safe) using Tool or Code.'
        'leave                      -- to leave a place only if a place was entered with use of open() command.'
        'examine *something*        -- to get more specified description of place or thing if description is known.'
        'ask *person*               -- to ask other characters (specified Person or group) about things.'
        'look                       -- to look around you again.'
        'instructions               -- to see this message again.'
        'end_game                   -- to end game (you win if all missions are complited).'
        'quit                       -- to end the game and quit.'
        ''
    ).

    Game class >> new [
        | g |
        g := super new.
        g init.
        ^ g
    ]

    init [


        "Obtainable."
        drill := Obtainable new.
        drill name: 'drill'.
        drill finishing: true.

        barrow := Obtainable new.
        barrow name: 'barrow'.

        beams := Obtainable new.
        beams name: 'beams'.

        hammers := Obtainable new.
        hammers name: 'hammers'.

        windows := Obtainable new.
        windows name: 'windows'.

        axe := Obtainable new.
        axe name: 'axe'.

        crowbar := Obtainable new.
        crowbar name: 'crowbar'.

        porsche_keys := Obtainable new.
        porsche_keys name: 'porsche_keys'.
        porsche_keys finishing: true.

        bmw_keys := Obtainable new.
        bmw_keys name: 'bmw_keys'.
        bmw_keys finishing: true.

        jeep_keys := Obtainable new.
        jeep_keys name: 'jeep_keys'.
        jeep_keys finishing: true.



        "Searchable"
        blue_container := Searchable new.
        blue_container name: 'blue_container'.
        blue_container description: #(
            'You search blue container and find: '
            ).
        blue_container addContent: drill.

        white_container := Searchable new.
        white_container description: #(
            'You search white container and find: '
            ).
        white_container name: 'white_container'.

        black_container := Searchable new.
        black_container name: 'black_container'.
        black_container description: #(
            'You search black container and find: '
            ).
        black_container addContent: beams.

        red_container := Searchable new.
        red_container name: 'red_container'.
        red_container description: #(
            'You search red container and find: '
            ).
        red_container addContent: hammers.

        yellow_container := Searchable new.
        yellow_container name: 'yellow_container'.
        yellow_container description: #(
            'You search yellow container and find: '
            ).
        yellow_container addContent: barrow.

        green_container := Searchable new.
        green_container name: 'green_container'.
        green_container description: #(
            'You search green container and find: '
            ).
        green_container addContent: windows.

        neighbourhood := Searchable new.
        neighbourhood name: 'neighbourhood'.
        neighbourhood description: #(
            'You notice an interesting pattern.'
            'Every third house on the other side of the road has a blue roof, other ones have red roofs.'
            'What''s more, houses with blue roof have a black-roofed house in front of them, other ones have green roofs.'
            'You also notice that the leftmost house on the other side of the road has a blue roof and house number 1.'
            'On one side on the road there are only even house numbers, on the other only odd'
            ).

        envelope := Searchable new.
        envelope name: 'envelope'.
        envelope description: #(
            'Dear residents of Mayfair St.'
            'Due to scheduled replacement of intercoms in upcoming week, we kindly inform you, '
            'that access password to mansion gate will be changed to combination of your mansion''s'
            'roof colour and address'' number(example: black1234).'
            'We are sorry for the inconvenience'
            'Best regards'
            'VH housing'
            ).

        gate := Searchable new.
        gate name: 'gate'.
        gate description: #(
            'The mansion’s gate is secured. You need a password to get through.'
            ).

        porsche := Searchable new.
        porsche name: 'porsche'.
        porsche description: #(
            'A sports coupe, that can go through paved roads very quickly.'
            ).

        bmw := Searchable new.
        bmw name: 'bmw'.
        bmw description: #(
            'An armored version of this car, that can withstand gunshots, at cost of not being too fast.'
            ).

        jeep := Searchable new.
        jeep name: 'jeep'.
        jeep description: #(
            'A quick SUV, capable of driving through more remote terrain.'
            ).

        shelf := Searchable new.
        shelf name: 'shelf'.
        shelf description: #(
            'You took a closer look at objects on the shelf and found:'
            ).
        shelf addContent: axe.
        shelf addContent: crowbar.

        first_drawer := Searchable new.
        first_drawer name: 'first_drawer'.
        first_drawer description: #(
            'You take a look inside the first drawer'
            ).

        second_drawer := Searchable new.
        second_drawer name: 'second_drawer'.
        second_drawer description: #(
            'You take a look inside the second drawer'
            ).

        third_drawer := Searchable new.
        third_drawer name: 'third_drawer'.
        third_drawer description: #(
            'You take a look inside the third drawer'
            ).
        third_drawer addContent: porsche_keys.

        fourth_drawer := Searchable new.
        fourth_drawer name: 'third_drawer'.
        fourth_drawer description: #(
            'You take a look inside the fourth drawer'
            ).
        fourth_drawer addContent: bmw_keys.

        fifth_drawer := Searchable new.
        fifth_drawer name: 'third_drawer'.
        fifth_drawer description: #(
            'You take a look inside the fifth drawer'
            ).
        fifth_drawer addContent: jeep_keys.



        "NPCs"
        supervisor := Npc new.
        supervisor
            name: 'supervisor';
            message: 'Hey how are you? It''s beautiful weather out there isn''t it?'.

        worker := Npc new.
        worker
            name: 'worker';
            message: 'Check out this building, it''s beautiful, isn''t it? I can''t wait till we finish it!'.



        "Places."
        lobby := Location new.
        lobby name: 'lobby'.
        lobby description: #(
            'You are currently in the lobby.'
            'You can either start unfinished mission or finish the game from here.'
            ''
        ).

        construction_site_south_gate := Location new.
        construction_site_south_gate name: 'construction_site_south_gate'.
        construction_site_south_gate description: #(
            'You are in front of south gate of a construction site.'
            'There is a supervisor next to you. You can talk with him.'
            'On the construction site at north, there are workers in a building'
            'and containers with various construction equipment. Find the drill.'
            ''
        ).
        construction_site_south_gate addAskable: supervisor.
        construction_site_south_gate finishing: true.


        construction_site := Location new.
        construction_site name: 'construction_site'.
        construction_site description: #(
            'You entered construction site area.'
            'There is a row of colorful containers to your right site.'
            'You can also take a closer look at construction workers.'
            ''
        ).
        construction_site addAskable: worker.

        containers := Location new.
        containers name: 'containers'.
        containers description: #(
            'You are now standing in front of a row of containers.'
            ''
        ).
        containers addSearchable: blue_container.
        containers addSearchable: red_container.
        containers addSearchable: yellow_container.
        containers addSearchable: white_container.
        containers addSearchable: black_container.
        containers addSearchable: green_container.


        construction_site_east_gate := Location new.
        construction_site_east_gate name: 'construction_site_east_gate'.
        construction_site_east_gate description: #(
            'You reached the east gate of the construction site.'
            'There''s not much here, but this place seems like'
            'another escape point'
            ''
        ).
        construction_site_east_gate finishing: true.

        vinewood_hills := Location new.
        vinewood_hills name: 'vinewood_hills'.
        vinewood_hills description: #(
            'You are in front of a luxury mansion in expensive neighbourhood of Los Santos - Vinewood Hills.'
            'There is a closed gate, that requires a password.'
            'You look around the neighbourhood and notice, that number of the house to the left is 18, '
            'and a mailbox with an envelope sticking out of it.'
            'Find keys to the car you want to steal, take them and go to the choosen car, then you can finish mission'
            ''
        ).
        vinewood_hills addSearchable: neighbourhood.
        vinewood_hills addSearchable: envelope.
        vinewood_hills addSearchable: gate.

        mansion_frontyard := Location new.
        mansion_frontyard name: 'mansion_frontyard'.
        mansion_frontyard description: #(
            'You entered mansion frontyard.'
            'There is a pavement leading to the back of the house and a wooden outbuilding on the right side.'
            'You also notice 3 cars standing on a driveway: .'
            ''
        ).
        mansion_frontyard addSearchable: porsche.
        mansion_frontyard addSearchable: bmw.
        mansion_frontyard addSearchable: jeep.

        outbuilding := Location new.
        outbuilding name: 'outbuilding'.
        outbuilding description: #(
            'You are inside of a wooden outbuilding. You notice a shelf,'
            'there should be some tools around you.'
            ''
        ).
        outbuilding addSearchable: shelf.




        "Mission progress."
        drill_mission := Mission new.
        drill_mission
            name: 'drill';
            finished: false;
            startLocation: construction_site_south_gate.

        car_mission := Mission new.
        car_mission
            name: 'car';
            finished: false;
            startLocation: vinewood_hills.

        weapon_mission := Mission new.
        weapon_mission
            name: 'weapon';
            finished: false;
            startLocation: construction_site_south_gate.



        "Connections."
        construction_site_south_gate_N_construction_site := LocationsStandardConnection new.
        construction_site_south_gate_N_construction_site
            currentLocation: construction_site_south_gate;
            direction: 'n';
            newLocation: construction_site.

        construction_site_S_construction_site_south_gate := LocationsStandardConnection new.
        construction_site_S_construction_site_south_gate
            currentLocation: construction_site;
            direction: 's';
            newLocation: construction_site_south_gate.

        construction_site_E_containers := LocationsStandardConnection new.
        construction_site_E_containers
            currentLocation: construction_site;
            direction: 'e';
            newLocation: containers.

        containers_W_construction_site := LocationsStandardConnection new.
        containers_W_construction_site
            currentLocation: containers;
            direction: 'w';
            newLocation: construction_site.

        containers_E_construction_site_east_gate := LocationsStandardConnection new.
        containers_E_construction_site_east_gate
            currentLocation: containers;
            direction: 'e';
            newLocation: construction_site_east_gate.

        construction_site_east_gate_W_containers := LocationsStandardConnection new.
        construction_site_east_gate_W_containers
            currentLocation: construction_site_east_gate;
            direction: 'w';
            newLocation: containers.

        vinewood_hills_black20_mansion_frontyard := LocationsPasswordConnection new.
        vinewood_hills_black20_mansion_frontyard
            currentLocation: vinewood_hills;
            password: 'black20';
            middle: gate;
            newLocation: mansion_frontyard.

        mansion_frontyard_E_outbuilding := LocationsStandardConnection new.
        mansion_frontyard_E_outbuilding
            currentLocation: mansion_frontyard;
            direction: 'e';
            newLocation: outbuilding.

        outbuilding_W_mansion_frontyard := LocationsStandardConnection new.
        outbuilding_W_mansion_frontyard
            currentLocation: outbuilding;
            direction: 'w';
            newLocation: mansion_frontyard.


        "Game state."
        isGameOver := false.
        current_mission := 'none'.

        location := lobby.

        has := 'nothing'.
    ]

    "Print strings from array in separate lines."
    printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
    ]

    printIntroduction [
        self printLines: introductionText
    ]

    printInstructions [
        self printLines: instructionsText
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]


    move: aDirection [
        | possibleConnections connection |
        possibleConnections := {
            construction_site_S_construction_site_south_gate.
            construction_site_south_gate_N_construction_site.
            construction_site_E_containers.
            containers_W_construction_site.
            containers_E_construction_site_east_gate.
            construction_site_east_gate_W_containers.
            mansion_frontyard_E_outbuilding.
            outbuilding_W_mansion_frontyard
        }.

        connection := possibleConnections
            detect: [ :c |
                c currentLocation name = location name
                    and: [ c direction = aDirection ]
            ]
            ifNone: [ nil ].

        connection
            ifNil: [
                self printLines: #('You cannot move in that direction.' '')
            ]
            ifNotNil: [
                location := connection newLocation.
                self look.
            ].
    ]


    open: middle code: code [
        | possibleConnections connection |

        possibleConnections := {
            vinewood_hills_black20_mansion_frontyard
        }.

        connection := possibleConnections
            detect: [ :c |
                (c currentLocation name = location name) and: [
                    (c password = code) and: [
                        c middle name = middle
                    ]
                ]
            ]

            ifNone: [ nil ].

        connection
            ifNil: [
                self printLines: #('Access Denied' '')
            ]
            ifNotNil: [
                location := connection newLocation.
                Transcript show: 'You successfully opened ', middle, ' and moved to ', location name; cr; cr.
                self look.
            ].
    ]


    examine: searchableName [
        | searchable items |

        "Znajdź obiekt Searchable o podanej nazwie w bieżącej lokalizacji."
        searchable := location searchable
            detect: [:aSearchable | aSearchable name = searchableName ]
            ifNone: [ nil ].

        searchable
            ifNil: [
                self printLines: #('There is no such searchable object here.' '')
            ]
            ifNotNil: [
                items := searchable content.

                items isEmpty
                    ifTrue: [
                        self printLines: searchable description.
                    ]
                    ifFalse: [
                        self printLines: searchable description.
                        items do: [:item |
                            Transcript show: item asString; cr.
                            location addThing: item.
                        ].
                        searchable content: OrderedCollection new.
                    ].
            ].
        Transcript cr.
    ]


    take: itemName [
        | item |

        item := location obtainable
            detect: [:anItem | anItem name = itemName ]
            ifNone: [ nil ].

        item
            ifNil: [
                self printLines: #('There is no such item here.' '')
            ]
            ifNotNil: [
                has = 'nothing'
                    ifFalse: [
                        self printLines: #('You are already holding something. Drop it first to take another item.' '')
                    ]
                    ifTrue: [
                        has := item.
                        location removeThing: item.
                        Transcript show: 'You picked up ', item asString, '.'; cr; cr.
                    ].
            ].
    ]


    drop [
        has = 'nothing'
            ifTrue: [
                self printLines: #('You are not holding anything to drop.' '')
            ]
            ifFalse: [
                location addThing: has.
                Transcript show: 'You dropped ', has asString, '.'; cr; cr.
                has := 'nothing'.
            ].
    ]


    look [
        | obtainable askable searchable |
        self printLines: location description.

        askable := location listAskable.

        askable isEmpty
            ifFalse: [
                askable do: [:hing |
                    Transcript show: 'You meet ', hing asString, ' here'; cr.
                ].
            ].

        Transcript cr.

        searchable := location listSearchable.

        searchable isEmpty
            ifFalse: [
                searchable do: [:thing |
                    Transcript show: 'There is a ', thing asString, ' here'; cr.
                ].
            ].

        Transcript cr.

        obtainable := location listObtainable.

        obtainable isEmpty
            ifFalse: [
                obtainable do: [:thing |
                    Transcript show: 'There is a ', thing asString, ' laying here'; cr.
                ].
            ].

        Transcript cr.
    ]


    ask: aNpcName [
        | npc |

        npc := location askable
            detect: [:someNpc | someNpc name = aNpcName ]
            ifNone: [ nil ].

        npc
            ifNil: [
                self printLines: #('There is no such person here.' '')
            ]
            ifNotNil: [
                Transcript show: npc message; cr; cr
            ].
    ]


    finish_mission [
        | currentMission currentItem currentLoc matchingMission |

        currentItem := has.
        currentLoc := location.
        currentMission := current_mission.

        (currentItem ~= 'nothing')
            ifTrue: [
                (currentLoc finishing)
                    ifTrue: [
                        (currentItem finishing)
                            ifTrue: [
                                Transcript show: 'You successfully completed mission ', current_mission; cr; cr.
                                location := lobby.
                                currentMission finished: true.
                                current_mission := 'none'.
                                has := 'nothing'.
                                self look
                            ]
                            ifFalse: [
                                self printLines: #('You cannot finish the mission yet.' '')
                            ].
                        ]
                    ifFalse: [
                        self printLines: #('You cannot finish the mission yet.' '')
                    ].
            ]
            ifFalse: [
                self printLines: #('You need to obtain certain objects in order to finish the mission.' '')
            ].
    ]


    choose_mission: missionName [
        (location name = 'lobby')
            ifFalse: [
                self printLines: #('You must be in the lobby to choose a mission.' '')
            ]
            ifTrue: [
                | allMissions foundMission |
                allMissions := { drill_mission. car_mission. weapon_mission }.

                foundMission := allMissions
                    detect: [ :c | c name = missionName ]
                    ifNone: [ nil ].

                foundMission
                    ifNil: [
                        self printLines: #('No such mission.' '')
                    ]
                    ifNotNil: [
                        foundMission finished
                            ifTrue: [
                                self printLines: #('You have already finished this mission.' '')
                            ]
                            ifFalse: [
                                location := foundMission startLocation.
                                current_mission := foundMission.
                                Transcript show: 'You have chosen mission: ', foundMission name; cr; cr.
                                self look
                            ].
                    ].
            ].
    ]


    "Main game loop."
    run [
        | cmd isUnknown parts secondArgument thirdArgument |

        self printIntroduction.
        self printInstructions.

        [ isGameOver ] whileFalse: [
            isUnknown := true.
            cmd := self readCommand.
            parts := cmd subStrings: ' '.

            (parts size = 3 and: [ parts first = 'open' ]) ifTrue: [
                secondArgument := parts second.
                thirdArgument := parts third.
                self open: secondArgument code: thirdArgument.
                isUnknown := false
            ].

            (parts size = 2 and: [ parts first = 'ask' ]) ifTrue: [
                secondArgument := parts second.
                self ask: secondArgument.
                isUnknown := false
            ].

            (parts size = 2 and: [ parts first = 'choose_mission' ]) ifTrue: [
                secondArgument := parts second.
                self choose_mission: secondArgument.
                isUnknown := false
            ].

            (parts size = 2 and: [ parts first = 'take' ]) ifTrue: [
                secondArgument := parts second.
                self take: secondArgument.
                isUnknown := false
            ].

            (parts size = 2 and: [ parts first = 'examine' ]) ifTrue: [
                secondArgument := parts second.
                self examine: secondArgument.
                isUnknown := false
            ].

            cmd = 'finish_mission' ifTrue: [
                self finish_mission.
                isUnknown := false
            ].

            cmd = 'drop' ifTrue: [
                self drop.
                isUnknown := false
            ].

            cmd = 'instructions' ifTrue: [
                self printInstructions.
                isUnknown := false
            ].

            cmd = 'quit' ifTrue: [
                isGameOver := true.
                isUnknown := false
            ].

            cmd = 'look' ifTrue: [
                self look.
                isUnknown := false
            ].

            cmd = 'n' ifTrue: [
                self move: 'n'.
                isUnknown := false
            ].

            cmd = 's' ifTrue: [
                self move: 's'.
                isUnknown := false
            ].

            cmd = 'w' ifTrue: [
                self move: 'w'.
                isUnknown := false
            ].

            cmd = 'e' ifTrue: [
                self move: 'e'.
                isUnknown := false
            ].

            isUnknown ifTrue: [
                self printLines: #('Unknown command.' '')
            ].
        ] "end whileFalse:"
    ]
].

Game new run.


