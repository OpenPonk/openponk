Class {
	#name : 'OPRSDraggableControlPoints',
	#superclass : 'RSInteraction',
	#instVars : [
		'handles',
		'midpointHandles',
		'isActive',
		'line',
		'canvas'
	],
	#category : 'OpenPonk-Roassal-Polyline',
	#package : 'OpenPonk-Roassal',
	#tag : 'Polyline'
}

{ #category : 'private' }
OPRSDraggableControlPoints >> connectWithCanvas [

	| interaction |
	interaction := canvas propertyAt: OPRSSelectableCanvas ifAbsent: [
		               line
			               when: RSMouseLeftClick
			               do: [ :event | self showHandles ]
			               for: self.
		               canvas
			               when: RSMouseLeftClick
			               do: [ :event |
			               event shape = line ifFalse: [ self removeHandles ] ]
			               for: self.
		               ^ self ].
	interaction
		when: OPRSSelectionEndEvent
		do: [ :event |
			(event selectedShapes includes: line)
				ifTrue: [ self showHandles ]
				ifFalse: [ self removeHandles ] ]
		for: self
]

{ #category : 'initialization' }
OPRSDraggableControlPoints >> enable [

	canvas := line canvas.
	line propertyAt: self class put: self.
	line when: RSShapeRemovedEvent do: [ self remove ] for: self.
	self connectWithCanvas
]

{ #category : 'initialization' }
OPRSDraggableControlPoints >> initialize [
	super initialize.
	handles := OrderedCollection new.
	midpointHandles := OrderedCollection new.
	isActive := false
]

{ #category : 'initialization' }
OPRSDraggableControlPoints >> onShape: aLine [

	line := aLine.
	line canvas
		ifNil: [ line when: RSShapeAddedEvent do: [ self enable ] for: self ]
		ifNotNil: [ self enable ]
]

{ #category : 'as yet unclassified' }
OPRSDraggableControlPoints >> promoteFor: aLine handle: aMidpointHandle [

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

{ #category : 'private' }
OPRSDraggableControlPoints >> rebuild [

	isActive ifFalse: [ ^ self ].
	self removeHandles.
	line update.
	self showHandles.
	line signalUpdate
]

{ #category : 'private' }
OPRSDraggableControlPoints >> remove [

	self removeHandles.
	line announcer unsubscribe: self.
	canvas ifNil: [ ^ self ].
	canvas announcer unsubscribe: self
]

{ #category : 'private' }
OPRSDraggableControlPoints >> removeHandles [
	isActive
		ifFalse: [ ^ self ].
	handles do: #remove.
	handles := OrderedCollection new.
	midpointHandles do: #remove.
	midpointHandles := OrderedCollection new.
	line signalUpdate.
	isActive := false
]

{ #category : 'as yet unclassified' }
OPRSDraggableControlPoints >> showHandles [

	isActive ifTrue: [ ^ self ].
	line innerControlPoints withIndexDo: [ :each :index |
		handles add: (OPRSDraggableControlPointHandle new
				 on: line atControlPoint: index + 1;
				 render;
				 yourself) ].
	self showMidpointHandles.
	line signalUpdate.
	isActive := true
]

{ #category : 'as yet unclassified' }
OPRSDraggableControlPoints >> showMidpointHandles [

	((line isKindOf: RSBezier) and: [ line controlPoints size >= 4 ]) 
		ifTrue: [ ^ self ].
	midpointHandles := { line from }
	                   , (handles collect: [ :each | each shape ])
	                   , { line to } overlappingPairsCollect: [ :from :to | 
		                   OPRSControlPointCreatorHandle new
			                   on: line between: from and: to;
			                   yourself ].
	midpointHandles first beNearStart.
	midpointHandles last beNearEnd.
	midpointHandles do: #render
]

{ #category : 'initialization' }
OPRSDraggableControlPoints >> showOnShape: aLine [

	line := aLine.
	line when: RSMouseLeftClick do: [ self showHandles ].
	line when: RSShapeRemovedEvent do: [ self removeHandles ].
	self connectWithCanvas
]
