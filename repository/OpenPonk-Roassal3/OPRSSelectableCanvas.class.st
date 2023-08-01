Class {
	#name : #OPRSSelectableCanvas,
	#superclass : #RSElasticBoxInteraction,
	#instVars : [
		'multiselectEnabled'
	],
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #public }
OPRSSelectableCanvas class >> rightLeft [

	^ self new
		  rightLeft;
		  yourself
]

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
		enableMultiselect
]

{ #category : #hooks }
OPRSSelectableCanvas >> onShape: aCanvas [

	(aCanvas getInteractionsForClass: RSDraggableCanvasInteraction) do: [
		:each | each mouseEvent: self dragStartEvent ].
	aCanvas
		when: self dragStartEvent send: #enableDrag: to: self;
		when: self boxStartEvent send: #disableDrag: to: self;
		when: RSMouseDragging send: #processDrag: to: self;
		when: RSMouseDragEnd send: #processDragEnd: to: self;
		when: RSMouseLeftClick
		do: [ :evt | self selectShapes: { aCanvas } byEvent: evt ]
		for: self.
	aCanvas propertyAt: self class put: self
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
