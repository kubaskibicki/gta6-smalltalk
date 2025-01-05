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
]



Object subclass: Npc [
    | name location message |

    name: aName [
        name := aName
    ]

    npcLocation: aLocation [
        location := aLocation
    ]

    message: aMessage [
        message := aMessage
    ]

    name [
        ^ name
    ]

    npcLocation [
        ^ location
    ]

    message [
        ^ message
    ]


]


Object subclass: Location [
    | location |

    "setter"
    location: aString [
        location := aString
    ]

    "getter"
    location [
        ^ location
    ]
]

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
]

Object subclass: Game [
    | isGameOver

        drill_mission
        car_mission
        weapon_mission

        current_mission
        location

        construction_site_south_gate_N_construction_site
        construction_site_S_construction_site_south_gate
        construction_site_E_containers
        containers_W_construction_site
        containers_E_construction_site_east_gate
        construction_site_east_gate_W_containers

        worker
        supervisor
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
        isGameOver := false.
        current_mission := 'none'.

        "Najpierw sie robi obiekt klasy location, potem wywolywany jest setter, stad taka dziwna konstrukcja."
        location := Location new.
        location location: 'lobby'.

        construction_site_south_gate_N_construction_site := LocationsConnection new.
        construction_site_south_gate_N_construction_site
            currentLocation: (Location new location: 'construction_site_south_gate');
            direction: 'n';
            newLocation: (Location new location: 'construction_site').

        construction_site_S_construction_site_south_gate := LocationsConnection new.
        construction_site_S_construction_site_south_gate
            currentLocation: (Location new location: 'construction_site');
            direction: 's';
            newLocation: (Location new location: 'construction_site_south_gate').

        construction_site_E_containers := LocationsConnection new.
        construction_site_E_containers
            currentLocation: (Location new location: 'construction_site');
            direction: 'e';
            newLocation: (Location new location: 'containers').

        containers_W_construction_site := LocationsConnection new.
        containers_W_construction_site
            currentLocation: (Location new location: 'containers');
            direction: 'w';
            newLocation: (Location new location: 'construction_site').

        containers_E_construction_site_east_gate := LocationsConnection new.
        containers_E_construction_site_east_gate
            currentLocation: (Location new location: 'containers');
            direction: 'e';
            newLocation: (Location new location: 'construction_site_east_gate').

        construction_site_east_gate_W_containers := LocationsConnection new.
        construction_site_east_gate_W_containers
            currentLocation: (Location new location: 'construction_site_east_gate');
            direction: 'w';
            newLocation: (Location new location: 'containers').

        supervisor := Npc new.
        supervisor
            name: 'supervisor';
            npcLocation: (Location new location: 'construction_site_south_gate');
            message: 'Hey how are you? It''s beautiful weather out there isn''t it?'.

        worker := Npc new.
        worker
            name: 'worker';
            npcLocation: (Location new location: 'construction_site');
            message: 'Check out this building, it''s beautiful, isn''t it? I can''t wait till we finish it!'.

        drill_mission := Mission new.
        drill_mission
            name: 'drill';
            finished: false;
            startLocation: (Location new location: 'construction_site_south_gate').

        car_mission := Mission new.
        car_mission
            name: 'car';
            finished: false;
            startLocation: (Location new location: 'vinewood_hills').

        weapon_mission := Mission new.
        weapon_mission
            name: 'weapon';
            finished: false;
            startLocation: (Location new location: 'gang_hideout').
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
                c currentLocation location = location location
                    and: [ c direction = aDirection ]
            ]
            ifNone: [ nil ].

        connection
            ifNil: [
                self printLines: #('You cannot move in that direction.' '')
            ]
            ifNotNil: [
                location := connection newLocation.
                Transcript show: 'You moved to: ', location location; cr; cr
            ].
    ]

    ask: aNpc [
        | allNpcs npc |

        allNpcs := {
            supervisor.
            worker
        }.

        npc := allNpcs
            detect: [ :c |
                c npcLocation location = location location
                    and: [ c name = aNpc ]
            ]
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
    (location location = 'lobby')
        ifFalse: [
            self printLines: #('You must be in the lobby to choose a mission.' '')
        ]
        ifTrue: [
            | allMissions foundMission |
            allMissions := {
                drill_mission.
                car_mission.
                weapon_mission
            }.

            foundMission := allMissions
                detect: [ :c |
                c name = missionName
            ]
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
                            Transcript show: 'You have chosen mission: ', foundMission name; cr; cr
                        ].
                ].
        ].
]



    "Run the game."
    run [
        | cmd isUnknown parts secondArgument |

        self printIntroduction.
        self printInstructions.

        "Game loop."
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

            cmd = 'instructions' ifTrue: [
                self printInstructions.
                isUnknown := false
            ].

            cmd = 'quit' ifTrue: [
                isGameOver := true.
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
            ]
        ]
    ]

]

Game new run.
