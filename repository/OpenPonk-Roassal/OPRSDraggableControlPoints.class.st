"
Roassal interaction that enables drag-and-drop manipulation of routing control points along a line or edge. 
Creates visual handles at vertices and midpoints, allowing users to reshape edges dynamically.
"
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

{ #category : 'events' }
OPRSDraggableControlPoints >> announceWaypointsChangedFor: aLine old: oldWaypoints new: newWaypoints [
	| event targetCanvas |
	oldWaypoints = newWaypoints ifTrue: [ ^ self ].
	event := OPRSEdgeWaypointsChangedEvent new
		line: aLine;
		oldWaypoints: oldWaypoints asArray copy;
		newWaypoints: newWaypoints asArray copy;
		yourself.
	targetCanvas := aLine canvas.
	targetCanvas ifNotNil: [ :c | c announce: event ]
]

{ #category : 'actions' }
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

{ #category : 'actions' }
OPRSDraggableControlPoints >> enable [

	canvas := line canvas.
	line propertyAt: self class put: self.
	line when: RSShapeRemovedEvent do: [ self remove ] for: self.
	self connectWithCanvas
]

{ #category : 'accessing' }
OPRSDraggableControlPoints >> handles [
	^ handles
]

{ #category : 'initialization' }
OPRSDraggableControlPoints >> initialize [
	super initialize.
	handles := OrderedCollection new.
	midpointHandles := OrderedCollection new.
	isActive := false
]

{ #category : 'accessing' }
OPRSDraggableControlPoints >> midpointHandles [
	^ midpointHandles
]

{ #category : 'hooks' }
OPRSDraggableControlPoints >> onShape: aLine [

	line := aLine.
	line canvas
		ifNil: [ line when: RSShapeAddedEvent do: [ self enable ] for: self ]
		ifNotNil: [ self enable ]
]

{ #category : 'actions' }
OPRSDraggableControlPoints >> promoteFor: aLine handle: aMidpointHandle [
	"Insert a new control point at midpoint position, supply initial waypoints to the new handle, rebuild handles, and transfer active drag focus to the newly created handle."
	| originalWaypoints insertedIndex newControlPointHandle |
	originalWaypoints := aLine controlPoints copy.
	aLine from = aMidpointHandle from
		ifTrue: [
			insertedIndex := 2.
			aLine controlPoints: {
					aLine controlPoints first.
					aMidpointHandle shape position } , aLine controlPoints allButFirst ]
		ifFalse: [
			| indexOfMidpointHandle |
			indexOfMidpointHandle := handles detectIndex: [ :eachHandle |
				                         eachHandle shape = aMidpointHandle from ].
			insertedIndex := indexOfMidpointHandle + 2.
			aLine controlPoints:
				(aLine controlPoints first: indexOfMidpointHandle + 1)
				, { aMidpointHandle shape position }
				, (aLine controlPoints allButFirst: indexOfMidpointHandle + 1) ].
	self rebuild.
	newControlPointHandle := handles
		detect: [ :eachHandle | eachHandle indexOfControlPoint = insertedIndex ]
		ifNone: [ nil ].
	newControlPointHandle ifNotNil: [ :targetHandle |
		targetHandle initialWaypoints: originalWaypoints ].
	aLine canvas ifNotNil: [ :targetCanvas |
		targetCanvas morph ifNotNil: [ :canvasMorph |
			canvasMorph resetShapeBeingDragged ] ]
]

{ #category : 'actions' }
OPRSDraggableControlPoints >> rebuild [

	isActive ifFalse: [ ^ self ].
	self removeHandles.
	line update.
	self showHandles.
	line signalUpdate
]

{ #category : 'actions' }
OPRSDraggableControlPoints >> remove [

	self removeHandles.
	line announcer unsubscribe: self.
	canvas ifNil: [ ^ self ].
	canvas
		propertyAt: OPRSSelectableCanvas
		ifPresent: [ :interaction | interaction announcer unsubscribe: self ].
	canvas announcer unsubscribe: self
]

{ #category : 'actions' }
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

{ #category : 'actions' }
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

{ #category : 'actions' }
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

{ #category : 'handles' }
OPRSDraggableControlPoints >> updateDuring: aBlock [
	"Safely tear down handles before executing aBlock to prevent zombie handles from receiving update events during geometry changes, then restore handles if they were active."
	| wasActive |
	wasActive := isActive.
	wasActive ifTrue: [ self removeHandles ].
	aBlock value.
	wasActive ifTrue: [ self showHandles ]
]
