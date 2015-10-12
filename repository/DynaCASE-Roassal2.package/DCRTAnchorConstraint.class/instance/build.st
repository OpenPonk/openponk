building
build
	self addAnchor.
	edge from addCallback: (TRTranslationCallback block: [ self update ]).
	edge to addCallback: (TRTranslationCallback block: [ self update ]).
	"Do a symbol-based check, because DCRTConnection is not (yet?) in Roassal"
	edge shape className asSymbol = #DCRTConnection
		| (edge shape className asSymbol = #DCRTStyledConnection)
		ifTrue: [ edge when: #DCRTHandleMoved asClass do: [ self update ] ].
	element
		when: TRMouseDragStart
		do: [ 
			guideLine color: Color gray.
			guideEdge update.
			guideEdge view signalUpdate ].
	element
		when: TRMouseDragEnd
		do:
			[ 
			guideLine color: Color transparent.
			guideEdge update.
			guideEdge view signalUpdate ]