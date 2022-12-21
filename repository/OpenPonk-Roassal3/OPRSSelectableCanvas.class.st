Class {
	#name : #OPRSSelectableCanvas,
	#superclass : #RSElasticBoxInteraction,
	#instVars : [
		'multiselectEnabled'
	],
	#category : #'OpenPonk-Roassal3'
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

	super onShape: aCanvas.
	aCanvas propertyAt: self class put: self.
	aCanvas
		when: RSMouseLeftClick
		do: [ :evt | self selectShapes: { aCanvas } byEvent: evt ]
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
