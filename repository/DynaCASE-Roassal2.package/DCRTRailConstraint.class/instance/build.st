building
build
	self addGrip.
	element when: TRMouseDragging do: [ self updateParameters ].
	element when: TRMouseDragEnd do: [ self updateParameters ].
	"	element addCallback: (TRTranslationCallback block: [ self updatePosition ])."
	connection from addCallback: (TRTranslationCallback block: [ self updatePosition ]).
	connection to addCallback: (TRTranslationCallback block: [ self updatePosition ]).
	connection when: DCRTHandleMoved do: [ self updatePosition ].
	self updatePosition