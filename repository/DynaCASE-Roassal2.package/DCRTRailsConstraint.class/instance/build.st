building
build
	self addGrip.
	element addCallback: (TRTranslationCallback block: [ self updatePosition ]).
	connection from addCallback: (TRTranslationCallback block: [ self updatePosition ]).
	connection to addCallback: (TRTranslationCallback block: [ self updatePosition ]).
	connection when: DCRTHandleMoved do: [ self updatePosition ].
	self updatePosition