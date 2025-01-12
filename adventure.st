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
    | name |

    name: aName [
        name := aName
    ]

    name [
        ^ name
    ]

    asString [
        ^ name
    ]
].

Object subclass: Searchable [
    | name content |

    name: aName [
        name := aName
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
    | name description searchable obtainable askable |

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
    | currentLocation direction newLocation |

    currentLocation: aLocation [
        currentLocation := aLocation
    ]

    currentLocation [
        ^ currentLocation
    ]

    direction: aDirection [
        direction := aDirection
    ]

    direction [
        ^ direction
    ]

    newLocation: aLocation [
        newLocation := aLocation
    ]

    newLocation [
        ^ newLocation
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

      "Searchable"
      blue_container
      white_container
      black_container
      red_container
      yellow_container
      green_container

      "Places"
      lobby
      construction_site_south_gate
      construction_site
      containers
      construction_site_east_gate

      "Places connections."
      construction_site_south_gate_N_construction_site
      construction_site_S_construction_site_south_gate
      construction_site_E_containers
      containers_W_construction_site
      containers_E_construction_site_east_gate
      construction_site_east_gate_W_containers

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
        'start                      -- to start the game.'
        'n.  s.  e.  w.             -- to go in that direction.'
        'choose_mission(Mission)    -- to start mission (options: car, drill, weapon).'
        'finish_mission             -- to finish mission (after completing required tasks - getting car keys or drill or type of weapon).'
        'take(Object)               -- to pick up an object.'
        'drop                       -- to put down an object.'
        'open(Thing, Tool/Code)     -- to open a secured (probably closed) Thing (can be gate, window or safe) using Tool or Code.'
        'leave(Place)               -- to leave a place only if a place was entered with use of open() command.'
        'examine(Something)         -- to get more specified description of place or thing if description is known.'
        'ask(Person)                -- to ask other characters (specified Person or group) about things.'
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

        barrow := Obtainable new.
        barrow name: 'barrow'.

        beams := Obtainable new.
        beams name: 'beams'.

        hammers := Obtainable new.
        hammers name: 'hammers'.

        windows := Obtainable new.
        windows name: 'windows'.



        "Searchable"
        blue_container := Searchable new.
        blue_container name: 'blue_container'.
        blue_container addContent: drill.

        white_container := Searchable new.
        white_container name: 'white_container'.

        black_container := Searchable new.
        black_container name: 'black_container'.
        black_container addContent: drill.

        red_container := Searchable new.
        red_container name: 'red_container'.
        red_container addContent: drill.

        yellow_container := Searchable new.
        yellow_container name: 'yellow_container'.
        yellow_container addContent: drill.

        green_container := Searchable new.
        green_container name: 'green_container'.
        green_container addContent: drill.



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
            startLocation: construction_site_south_gate.

        weapon_mission := Mission new.
        weapon_mission
            name: 'weapon';
            finished: false;
            startLocation: construction_site_south_gate.

        "Connections."
        construction_site_south_gate_N_construction_site := LocationsConnection new.
        construction_site_south_gate_N_construction_site
            currentLocation: construction_site_south_gate;
            direction: 'n';
            newLocation: construction_site.

        construction_site_S_construction_site_south_gate := LocationsConnection new.
        construction_site_S_construction_site_south_gate
            currentLocation: construction_site;
            direction: 's';
            newLocation: construction_site_south_gate.

        construction_site_E_containers := LocationsConnection new.
        construction_site_E_containers
            currentLocation: construction_site;
            direction: 'e';
            newLocation: containers.

        containers_W_construction_site := LocationsConnection new.
        containers_W_construction_site
            currentLocation: containers;
            direction: 'w';
            newLocation: construction_site.

        containers_E_construction_site_east_gate := LocationsConnection new.
        containers_E_construction_site_east_gate
            currentLocation: containers;
            direction: 'e';
            newLocation: construction_site_east_gate.

        construction_site_east_gate_W_containers := LocationsConnection new.
        construction_site_east_gate_W_containers
            currentLocation: construction_site_east_gate;
            direction: 'w';
            newLocation: containers.



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
            construction_site_east_gate_W_containers
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
                        self printLines: #('There is nothing inside.' '')
                    ]
                    ifFalse: [
                        Transcript show: 'You looked inside ', searchable asString, ', and found:'; cr.
                        items do: [:item |
                            Transcript show: item asString; cr.
                            location addThing: item.
                        ].
                        searchable content: OrderedCollection new.
                    ].
            ].
    ]


    take: itemName [
        | item |

        "Attempt to find the item in the obtainable list of the current location."
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

    "Spróbuj znaleźć NPC o danej nazwie wśród askable bieżącej lokacji."
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
                                current_mission := foundMission name.
                                Transcript show: 'You have chosen mission: ', foundMission name; cr; cr.
                                self look
                            ].
                    ].
            ].
    ]

    "Main game loop."
    run [
        | cmd isUnknown parts secondArgument |

        self printIntroduction.
        self printInstructions.

        [ isGameOver ] whileFalse: [
            isUnknown := true.
            cmd := self readCommand.
            parts := cmd subStrings: ' '.

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


