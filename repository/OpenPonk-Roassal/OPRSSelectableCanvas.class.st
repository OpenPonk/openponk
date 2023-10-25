Class {
	#name : #OPRSSelectableCanvas,
	#superclass : #RSElasticBoxInteraction,
	#instVars : [
		'multiselectEnabled'
	],
	#category : #'OpenPonk-Roassal-Interactions'
}

{ #category : #'event processing' }
OPRSSelectableCanvas >> boxEnded: event [

	| boxEvent |
	boxEvent := self createEvent: OPRSSelectionEndEvent with: event.
	boxEvent shape remove.
	event canvas removeKey: self className.
	boxEvent
		selectedShapes: selectedShapes;
		originalEvent: event.
	self announce: boxEvent.
	event signalUpdate
]

{ #category : #hooks }
OPRSSelectableCanvas >> boxStartEvent [

	^ RSMouseLeftDragStart
]

{ #category : #'event processing' }
OPRSSelectableCanvas >> boxStarted: event [

	multiselectEnabled ifFalse: [ ^ self ].
	^ super boxStarted: event
]

{ #category : #'event processing' }
OPRSSelectableCanvas >> boxUpdated: event [

	multiselectEnabled ifFalse: [ ^ self ].
	^ super boxUpdated: event
]

{ #category : #accessing }
OPRSSelectableCanvas >> color [
	^ Color black alpha: 0.2
]

{ #category : #'event processing' }
OPRSSelectableCanvas >> createCameraAnimation: event [
	"do nothing"

	
]

{ #category : #accessing }
OPRSSelectableCanvas >> defaultBox [

	^ super defaultBox
		  color: (Color black alpha: 0.2);
		  yourself
]

{ #category : #protocol }
OPRSSelectableCanvas >> disableMultiselect [

	multiselectEnabled := false
]

{ #category : #hooks }
OPRSSelectableCanvas >> dragStartEvent [

	^ RSMouseRightDragStart
]

{ #category : #protocol }
OPRSSelectableCanvas >> enableMultiselect [

	multiselectEnabled := true
]

{ #category : #initialization }
OPRSSelectableCanvas >> initialize [

	super initialize.
	selectedShapes := RSGroup new.
	self
		targetShapes: [ :canvas | canvas shapes select: #isSelectable ];
		enableMultiselect.
]

{ #category : #hooks }
OPRSSelectableCanvas >> onShape: aCanvas [

	(aCanvas getInteractionsForClass: RSDraggableCanvasInteraction) do: [
		:each | each mouseEvent: self dragStartEvent ].
	aCanvas
		when: self boxStartEvent send: #processDragStart: to: self;
		when: RSMouseDragging send: #processDragging: to: self;
		when: RSMouseDragEnd send: #processDragEnd: to: self;
		when: RSMouseLeftClick
		do: [ :evt | self selectShapes: { aCanvas } byEvent: evt ]
		for: self.
	aCanvas propertyAt: self class put: self
]

{ #category : #'event processing' }
OPRSSelectableCanvas >> processDragStart: event [

	shouldProcessInteraction := true.
	self boxStarted: event.
	self createCameraAnimation: event
]

{ #category : #hooks }
OPRSSelectableCanvas >> selectShapes: aGroup byEvent: anEvent [

	(multiselectEnabled not and: [ aGroup size > 1 ]) ifTrue: [ ^ self ].
	super boxStarted: anEvent.
	self announce:
		((self createEvent: RSSelectionChangedEvent with: anEvent)
			 oldSelectedShapes: selectedShapes;
			 selectedShapes: (selectedShapes := aGroup);
			 yourself).
	self boxEnded: anEvent
]

{ #category : #'event processing' }
OPRSSelectableCanvas >> stopCameraAnimation: event [
	"do nothing"

	
]
