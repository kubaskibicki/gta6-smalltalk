"The germ of a text adventure game
Marcin Szlenk 2024"

"Game class

Responsibilities:
* print/read outputs/inputs
* handle game loop
* handle 'instructions' and 'halt' commands

Collaborators:
* ..."

Object subclass: Game [
    | isGameOver |

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
        isGameOver := false
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

    "Run the game."
    run [
        | cmd isUnknown |

        self printIntroduction.
        self printInstructions.

        "Game loop."
        [isGameOver] whileFalse: [

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
                
            isUnknown ifTrue: [
                self printLines: #('Unknown command.' '')
            ]
        ]
    ]
]

Game new run.
