"
I add handles (interaction) to a DCRTConnection.
"
Class {
	#name : #OPRTConnectionHandles,
	#superclass : #RTInteraction,
	#instVars : [
		'edge',
		'handles',
		'midpointHandles',
		'isActive'
	],
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #private }
OPRTConnectionHandles >> connectWithView: aView [
	(aView hasAttribute: self className)
		ifFalse: [ self setupView: aView ].
	aView canvas eventOverseer
		when: TRMouseLeftClick
		do:
			[ :event | 
			(event element = edge) not & isActive
				ifTrue: [ self removeHandles ] ]
]

{ #category : #initialization }
OPRTConnectionHandles >> initialize [
	super initialize.
	handles := OrderedCollection new.
	midpointHandles := OrderedCollection new.
	isActive := false
]

{ #category : #initialization }
OPRTConnectionHandles >> initializeElement: anEdge [
	anEdge
		when: TRMouseLeftClick
		do:
			[ 
			anEdge announcer unsubscribe: self.
			self lazyInitializeElement: anEdge.
			self showHandles ]
]

{ #category : #initialization }
OPRTConnectionHandles >> lazyInitializeElement: anEdge [
	edge := anEdge.
	edge shape router handler: self.
	edge when: TRMouseLeftClick do: [ self showHandles ].
	edge trachelShape addCallback: (TRRemoveCallback block: [ self removeHandles ]).
	self connectWithView: edge view
]

{ #category : #'as yet unclassified' }
OPRTConnectionHandles >> promoteFor: anEdge handle: aMidpointHandle [
	| newPoint |
	"1. Add point at midpoint's place.
	 2. Remove midpoint handle.
	 3. Do full reload."
	newPoint := DoubleLink value: aMidpointHandle element position.
	anEdge from = aMidpointHandle from
		ifTrue: [ self router pointLinks addFirst: newPoint ]
		ifFalse: [ self router pointLinks add: newPoint afterLink: (handles detect: [ :each | each element = aMidpointHandle from ]) pointLink ].
	self rebuild.
	anEdge view canvas morph resetShapeBeingPointed
]

{ #category : #private }
OPRTConnectionHandles >> rebuild [
	isActive
		ifTrue: [ self removeHandles.
			self showHandles ].
	edge update.
	edge signalUpdate
]

{ #category : #private }
OPRTConnectionHandles >> removeHandles [
	isActive
		ifFalse: [ ^ self ].
	handles do: #remove.
	handles := OrderedCollection new.
	midpointHandles do: #remove.
	midpointHandles := OrderedCollection new.
	edge signalUpdate.
	isActive := false
]

{ #category : #'as yet unclassified' }
OPRTConnectionHandles >> router [
	^ edge shape router
]

{ #category : #private }
OPRTConnectionHandles >> setupView: aView [
	aView canvas eventOverseer ifNil: [ aView canvas eventOverseer: TRAnnouncingOverseer new ].
	aView attributeAt: self className put: true
]

{ #category : #'as yet unclassified' }
OPRTConnectionHandles >> showHandles [
	isActive
		ifTrue: [ ^ self ].
	edge shape router linksDo: [ :each | handles add: (OPRTHandle new on: edge at: each) ].
	handles do: [ :each | each renderIn: edge view ].
	self showMidpointHandlesFor: edge.
	edge signalUpdate.
	isActive := true
]

{ #category : #'as yet unclassified' }
OPRTConnectionHandles >> showMidpointHandlesFor: anEdge [
	midpointHandles := {anEdge from} , (handles collect: [ :each | each element ]) , {anEdge to}
		overlappingPairsCollect: [ :from :to | OPRTMidpointHandle new on: anEdge between: from and: to ].
	midpointHandles first beNearStart.
	midpointHandles last beNearEnd.
	midpointHandles do: [ :each | each renderIn: anEdge view ]
]
