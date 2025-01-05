Object subclass: Location [
    | location |

    "setter"
    location: aString [
        location := aString
    ]

    "getter"
    location [
        ^location
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
      location
      construction_site_south_gate_N_construction_site
      construction_site_S_construction_site_south_gate
      construction_site_E_containers
      containers_W_construction_site
      containers_E_construction_site_east_gate
      construction_site_east_gate_W_containers
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
        ^g
    ]

    init [
        isGameOver := false.
        location := 'construction_site_south_gate'.

        "polaczenia"
        construction_site_south_gate_N_construction_site := LocationsConnection new.
        construction_site_south_gate_N_construction_site currentLocation: 'construction_site_south_gate'.
        construction_site_south_gate_N_construction_site direction: 'n'.
        construction_site_south_gate_N_construction_site newLocation: 'construction_site'.

        construction_site_S_construction_site_south_gate := LocationsConnection new.
        construction_site_S_construction_site_south_gate currentLocation: 'construction_site'.
        construction_site_S_construction_site_south_gate direction: 's'.
        construction_site_S_construction_site_south_gate newLocation: 'construction_site_south_gate'.

        construction_site_E_containers := LocationsConnection new.
        construction_site_E_containers currentLocation: 'construction_site'.
        construction_site_E_containers direction: 'e'.
        construction_site_E_containers newLocation: 'containers'.

        containers_W_construction_site := LocationsConnection new.
        containers_W_construction_site currentLocation: 'containers'.
        containers_W_construction_site direction: 'w'.
        containers_W_construction_site newLocation: 'construction_site'.

        containers_E_construction_site_east_gate := LocationsConnection new.
        containers_E_construction_site_east_gate currentLocation: 'containers'.
        containers_E_construction_site_east_gate direction: 'e'.
        containers_E_construction_site_east_gate newLocation: 'construction_site_east_gate'.

        construction_site_east_gate_W_containers := LocationsConnection new.
        construction_site_east_gate_W_containers currentLocation: 'construction_site_east_gate'.
        construction_site_east_gate_W_containers direction: 'w'.
        construction_site_east_gate_W_containers newLocation: 'containers'.

    ]

    "Print strings from array in separate lines."
    printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
    ]

    printIntroduction [
       self printLines: introductionText.
    ]

    printInstructions [
        self printLines: instructionsText.
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    move: aDirection [
        | possibleConnections connection |

        possibleConnections := { construction_site_S_construction_site_south_gate.
                                 construction_site_south_gate_N_construction_site.
                                 construction_site_E_containers.
                                 containers_W_construction_site.
                                 containers_E_construction_site_east_gate.
                                 construction_site_east_gate_W_containers}.

        connection := possibleConnections
            detect: [ :c |
                c currentLocation = location and: [
                    c direction = aDirection
                ]
            ]
            ifNone: [ nil ].

        connection
            ifNil: [
                self printLines: #('You cannot move in that direction.' '')
            ]
            ifNotNil: [
                location := connection newLocation.
                Transcript cr; show: 'You moved to: ', location; cr.
            ].
    ]

    "Run the game."
    run [
        | cmd isUnknown |

        self printIntroduction.
        self printInstructions.

        "Game loop."
        [ isGameOver ] whileFalse: [

            isUnknown := true.
            cmd := self readCommand.

            cmd = 'instructions' ifTrue: [
                self printInstructions.
                isUnknown := false
            ].

            cmd = 'quit' ifTrue: [
                isGameOver := true.
                isUnknown := false
            ].

            cmd = 'n' ifTrue: [ self move: 'n'. isUnknown := false ].
            cmd = 's' ifTrue: [ self move: 's'. isUnknown := false ].
            cmd = 'w' ifTrue: [ self move: 'w'. isUnknown := false ].
            cmd = 'e' ifTrue: [ self move: 'e'. isUnknown := false ].

            isUnknown ifTrue: [
                self printLines: #('Unknown command.' '')
            ]
        ]
    ]
]

Game new run.
