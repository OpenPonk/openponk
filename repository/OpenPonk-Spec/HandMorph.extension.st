Extension { #name : 'HandMorph' }

{ #category : '*OpenPonk-Spec' }
HandMorph >> sendKeyboardEvent: anEvent [

	self flag:
		'Part of ugly hack to find out if ctrl is currently pressed'.
	OPDiagramRemoveFigureCommand lastEvent: anEvent.
	self flag:
		'Original method below'.
		
	"Send the event to the morph currently holding the focus, or if none to
	the owner of the hand."
	^ self
		sendEvent: anEvent
		focus: self keyboardFocus
		clear: [self keyboardFocus: nil]
]

{ #category : '*OpenPonk-Spec' }
HandMorph >> sendMouseEvent: anEvent [

	self flag:
		'Part of ugly hack to find out if ctrl is currently pressed'.
	OPDiagramRemoveFigureCommand lastEvent: anEvent.
	self flag:
		'Original method below'.
		
	"Send the event to the morph currently holding the focus, or if none to the owner of the hand."
	^self sendEvent: anEvent focus: self mouseFocus clear:[self mouseFocus: nil]
]
