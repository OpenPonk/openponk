Class {
	#name : 'OPRSResizable',
	#superclass : 'RSTransformable',
	#instVars : [
		'shape',
		'handles'
	],
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'accessing' }
OPRSResizable >> boxShape [

	^ super boxShape
		  borderColor: Color blue;
		  yourself
]

{ #category : 'hooks' }
OPRSResizable >> connectWithCanvas [

	| interaction |
	interaction := shape canvas
		               propertyAt: OPRSSelectableCanvas
		               ifAbsent: [
			               shape announcer
				               when: RSMouseLeftClick
				               send: #showHandles:
				               to: self.
			               ^ self ].
	interaction
		when: OPRSSelectionEndEvent
		do: [ :event |
			(event selectedShapes includes: shape)
				ifTrue: [ self showHandles: event ]
				ifFalse: [ self removeHandles: event ] ]
		for: self
]

{ #category : 'accessing - shapes' }
OPRSResizable >> createHandleFor: association [

	| handle |
	handle := super createHandleFor: association.
	handle
		size: 9;
		color: Color white;
		borderDo: [ :b | 
			b
				width: 2;
				color: Color blue ].
	^ handle
]

{ #category : 'hooks' }
OPRSResizable >> onShape: aShape [

	aShape isNode ifFalse: [ ^ self ].
	shape := aShape.
	shape isInACanvas
		ifTrue: [ self connectWithCanvas ]
		ifFalse: [
			shape
				when: RSShapeAddedEvent
				do: [ self connectWithCanvas ]
				for: self ].
	shape
		when: RSMouseDragStart send: #disableHandles: to: self;
		when: RSMouseDragEnd send: #enableHandles: to: self;
		when: OPRSDragFromSelectionStart send: #disableHandles: to: self;
		when: OPRSDragFromSelectionEnd send: #enableHandles: to: self.
	shape
		when: RSShapeRemovedEvent
		do: [ :evt |
			shape announcer unsubscribe: self.
			shape removePropertyAt: self key ifAbsent: [  ].
			self removeHandles: evt ]
		for: self
]

{ #category : 'private' }
OPRSResizable >> registerCanvasEventsIfNecessary: evt [

	(evt canvas hasProperty: OPRSSelectableCanvas) ifTrue: [ ^ self ].
	^ super registerCanvasEventsIfNecessary: evt
]

{ #category : 'private' }
OPRSResizable >> removeHandles: evt [

	| canvas |
	canvas := evt canvas.
	handles ifNil: [ ^ self ].

	handles do: #remove.
	handles := nil.
	canvas ifNotNil: #signalUpdate
]

{ #category : 'private' }
OPRSResizable >> saveCurrentShapeState [
	"do nothing"
]

{ #category : 'private' }
OPRSResizable >> saveHandles: newHandles evt: evt [

	handles := newHandles
]

{ #category : 'public' }
OPRSResizable >> showHandles: evt [

	| parent |
	self removeHandles: evt.
	self registerCanvasEventsIfNecessary: evt.
	shape propertyAt: self key put: #enable.
	self createHandlesFor: shape.

	parent := shape parent.
	parent addAll: handles.
	evt signalUpdate
]

{ #category : 'private' }
OPRSResizable >> updateCurrentShape: evt [

	| handle newRec rect |
	currentShape ifNil: [ ^ self ].
	handle := evt shape.
	newRec := self
		          perform: (handle model key , ':rectangle:') asSymbol
		          withArguments: { 
				          handle position.
				          currentShape encompassingRectangle }.

	rect := newRec value corner: newRec key.

	currentShape extent: rect extent.
	currentShape translateTo: rect floatCenter.

	self updateHandles: evt.
	evt signalUpdate
]

{ #category : 'private' }
OPRSResizable >> updateHandles: evt [

	| canvas rect base points circles matrix |
	currentShape ifNil: [ ^ self ].
	canvas := evt canvas.
	rect := currentShape baseRectangle.
	base := handles first.
	circles := handles copyFrom: 2 to: handles size.
	points := Array new: circles size.
	matrix := currentShape matrix.
	circles doWithIndex: [ :h :index | 
		| position |
		position := matrix transform: (h model key value: rect).
		h position: position.
		points at: index put: position ].
	base points: points

	"TODO
	rotate := handles last.
	rotate position: (matrix transform: rect topCenter - (0@30) )."
]
