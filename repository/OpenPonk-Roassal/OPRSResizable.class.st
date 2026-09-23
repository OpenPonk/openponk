"
Interaction decorating shapes with resize handles. Tracks resize gestures and keeps handles synchronized with external extent changes.
"
Class {
	#name : 'OPRSResizable',
	#superclass : 'RSTransformable',
	#instVars : [
		'shape',
		'handles',
		'isInteractivelyResizing',
		'initialExtent',
		'initialPosition'
	],
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'accessing - shapes' }
OPRSResizable >> boxShape [

	^ super boxShape
		  borderColor: Color blue translucent;
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
	handle
		when: RSMouseDragStart send: #handleDragStarted: to: self;
		when: RSMouseDragEnd send: #handleDragEnded: to: self.
	^ handle
]

{ #category : 'events' }
OPRSResizable >> handleDragEnded: evt [

	| currentExtent currentPos hasChanged targetCanvas resizedEvent |
	isInteractivelyResizing := false.
	shape ifNil: [ currentShape ifNotNil: [ :cs | shape := cs ] ].
	shape ifNil: [ ^ self ].
	currentExtent := shape extent copy.
	currentPos := shape position copy.
	hasChanged := initialExtent isNotNil and: [
		              initialPosition isNotNil and: [ initialExtent ~= currentExtent or: [ initialPosition ~= currentPos ] ] ].
	hasChanged ifTrue: [
			resizedEvent := OPRSShapeResizedEvent new
				                shape: shape;
				                oldExtent: initialExtent;
				                newExtent: currentExtent;
				                oldPosition: initialPosition;
				                newPosition: currentPos;
				                yourself.
			targetCanvas := (evt ifNotNil: [ evt canvas ]) ifNil: [ shape canvas ].
			targetCanvas ifNotNil: [ :c | c announce: resizedEvent ] ].
	initialExtent := nil.
	initialPosition := nil
]

{ #category : 'events' }
OPRSResizable >> handleDragStarted: evt [
	isInteractivelyResizing := true.
	shape ifNil: [ currentShape ifNotNil: [ :cs | shape := cs ] ].
	shape ifNotNil: [
		initialExtent := shape extent copy.
		initialPosition := shape position copy ]
]

{ #category : 'accessing' }
OPRSResizable >> handles [
	^ handles
]

{ #category : 'testing' }
OPRSResizable >> isInteractivelyResizing [
	^ isInteractivelyResizing ifNil: [ isInteractivelyResizing := false ]
]

{ #category : 'hooks' }
OPRSResizable >> onShape: aShape [
	aShape isNode ifFalse: [ ^ self ].
	shape := aShape.
	currentShape := aShape.
	shape propertyAt: self class put: self.
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
		when: RSExtentChangedEvent send: #relocateHandles to: self;
		when: RSPositionChangedEvent send: #relocateHandles to: self.
	shape
		when: RSShapeRemovedEvent
		do: [ :evt |
			shape announcer unsubscribe: self.
			shape removePropertyAt: self class ifAbsent: [  ].
			shape removePropertyAt: self key ifAbsent: [  ].
			self removeHandles: evt ]
		for: self
]

{ #category : 'private' }
OPRSResizable >> registerCanvasEventsIfNecessary: evt [

	(evt canvas hasProperty: OPRSSelectableCanvas) ifTrue: [ ^ self ].
	^ super registerCanvasEventsIfNecessary: evt
]

{ #category : 'update' }
OPRSResizable >> relocateHandles [
	self isInteractivelyResizing ifTrue: [ ^ self ].
	handles ifNil: [ ^ self ].
	self updateHandles: nil
]

{ #category : 'public' }
OPRSResizable >> removeHandles: anEvent [

	| canvas |
	canvas := anEvent
		ifNotNil: [ :theEvent | theEvent canvas ]
		ifNil: [ shape canvas ].
	handles ifNil: [ ^ self ].

	handles do: #remove.
	handles := nil.
	canvas ifNotNil: [ :theCanvas | theCanvas signalUpdate ]
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

{ #category : 'update' }
OPRSResizable >> updateCurrentShape: anEvent [
	| handle newRectangle normalizedRectangle currentRectangle |
	currentShape ifNil: [ ^ self ].
	handle := anEvent shape.
	currentRectangle := currentShape encompassingRectangle.
	newRectangle := self
		perform: (handle model key , ':rectangle:') asSymbol
		withArguments: {
			handle position.
			currentRectangle }.

	normalizedRectangle := (newRectangle key min: newRectangle value)
		corner: (newRectangle key max: newRectangle value).

	currentShape extent: normalizedRectangle extent.
	currentShape translateTo: normalizedRectangle floatCenter.

	self updateHandles: anEvent.
	anEvent signalUpdate
]

{ #category : 'update' }
OPRSResizable >> updateHandles: anEvent [
	| canvas rect baseHandle handleCircles pointPositions transformationMatrix halfExtent |
	currentShape ifNil: [ currentShape := shape ].
	currentShape ifNil: [ ^ self ].
	handles ifNil: [ ^ self ].
	handles size < 2 ifTrue: [ ^ self ].
	canvas := anEvent ifNotNil: [ :event | event canvas ] ifNil: [ currentShape canvas ].
	halfExtent := currentShape extent asFloatPoint / 2.0.
	rect := Rectangle origin: halfExtent negated corner: halfExtent.
	baseHandle := handles first.
	handleCircles := handles copyFrom: 2 to: handles size.
	pointPositions := Array new: handleCircles size.
	transformationMatrix := currentShape matrix.
	handleCircles doWithIndex: [ :eachHandle :index |
		| handlePosition |
		handlePosition := transformationMatrix transform: (eachHandle model key value: rect).
		eachHandle position: handlePosition.
		pointPositions at: index put: handlePosition ].
	baseHandle points: pointPositions.
	baseHandle resetBBox.
	canvas ifNotNil: [ :theCanvas | theCanvas signalUpdate ]
]
