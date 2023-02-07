Class {
	#name : #OPRSPolylineHandles,
	#superclass : #RSInteraction,
	#instVars : [
		'handles',
		'midpointHandles',
		'isActive',
		'line',
		'canvas'
	],
	#category : #'OpenPonk-Roassal3-Polyline'
}

{ #category : #private }
OPRSPolylineHandles >> connectWithCanvas [

	| interaction |
	interaction := canvas propertyAt: OPRSSelectableCanvas ifAbsent: [ 
		               line
			               when: RSMouseLeftClick
			               do: [ :event | self showHandles ].
		               canvas
			               when: RSMouseLeftClick
			               do: [ :event | 
			               event shape = line ifFalse: [ self removeHandles ] ].
		               ^ self ].
	interaction when: OPRSSelectionEndEvent do: [ :event | 
		(event selectedShapes includes: line)
			ifTrue: [ self showHandles ]
			ifFalse: [ self removeHandles ] ]
]

{ #category : #initialization }
OPRSPolylineHandles >> enable [

	canvas := line canvas.
	line propertyAt: self class put: self.
	line when: RSShapeRemovedEvent do: [ self remove ].
	self connectWithCanvas
]

{ #category : #initialization }
OPRSPolylineHandles >> initialize [
	super initialize.
	handles := OrderedCollection new.
	midpointHandles := OrderedCollection new.
	isActive := false
]

{ #category : #initialization }
OPRSPolylineHandles >> onShape: aLine [

	line := aLine.
	line canvas
		ifNil: [ line when: RSShapeAddedEvent do: [ self enable ] ]
		ifNotNil: [ self enable ]
]

{ #category : #'as yet unclassified' }
OPRSPolylineHandles >> promoteFor: aLine handle: aMidpointHandle [

	| newPoint |
	"1. Add point at midpoint's place.
	 2. Remove midpoint handle.
	 3. Do full reload."
	newPoint := aMidpointHandle shape position.
	aLine from = aMidpointHandle from
		ifTrue: [ 
			aLine controlPoints: { 
					aLine controlPoints first.
					newPoint } , aLine controlPoints allButFirst ]
		ifFalse: [ 
			| indexOfMidpointHandle |
			indexOfMidpointHandle := handles detectIndex: [ :each | 
				                         each shape = aMidpointHandle from ].
			aLine controlPoints:
				(aLine controlPoints first: indexOfMidpointHandle + 1)
				, { newPoint }
				, (aLine controlPoints allButFirst: indexOfMidpointHandle + 1) ].
	self rebuild.
	aLine canvas morph resetShapeBeingDragged
]

{ #category : #private }
OPRSPolylineHandles >> rebuild [

	isActive ifFalse: [ ^ self ].
	self removeHandles.
	line update.
	self showHandles.
	line signalUpdate
]

{ #category : #private }
OPRSPolylineHandles >> remove [

	self removeHandles.
	line announcer unsubscribe: self.
	canvas ifNil: [ ^ self ].
	canvas announcer unsubscribe: self
]

{ #category : #private }
OPRSPolylineHandles >> removeHandles [
	isActive
		ifFalse: [ ^ self ].
	handles do: #remove.
	handles := OrderedCollection new.
	midpointHandles do: #remove.
	midpointHandles := OrderedCollection new.
	line signalUpdate.
	isActive := false
]

{ #category : #'as yet unclassified' }
OPRSPolylineHandles >> showHandles [

	isActive ifTrue: [ ^ self ].
	line controlPoints
		from: 2
		to: line controlPoints size - 1
		do: [ :each | 
			handles add: (OPRSBendHandle new
					 on: line at: each;
					 render;
					 yourself) ].
	self showMidpointHandles.
	line signalUpdate.
	isActive := true
]

{ #category : #'as yet unclassified' }
OPRSPolylineHandles >> showMidpointHandles [

	midpointHandles := { line from }
	                   , (handles collect: [ :each | each shape ])
	                   , { line to } overlappingPairsCollect: [ :from :to | 
		                   OPRSMidpointHandle new
			                   on: line between: from and: to;
			                   yourself ].
	midpointHandles first beNearStart.
	midpointHandles last beNearEnd.
	midpointHandles do: #render
]

{ #category : #initialization }
OPRSPolylineHandles >> showOnShape: aLine [

	line := aLine.
	line when: RSMouseLeftClick do: [ self showHandles ].
	line when: RSShapeRemovedEvent do: [ self removeHandles ].
	self connectWithCanvas
]
