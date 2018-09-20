"
I constraint an element to be dragged only on the border of a provided ==background== element.

The border is defined by ==background=='s ==encompassingRectangle==.
"
Class {
	#name : #OPRTBorderDraggable,
	#superclass : #RTAbstractDraggable,
	#instVars : [
		'background'
	],
	#category : 'OpenPonk-Roassal2-Interactivity'
}

{ #category : #'instance creation' }
OPRTBorderDraggable class >> background: anElement [
	^ self new
		background: anElement;
		yourself
]

{ #category : #accessing }
OPRTBorderDraggable >> background: anElement [
	background := anElement
]

{ #category : #hooks }
OPRTBorderDraggable >> initializeElement: anElement [
	self
		assert: [ background isNotNil ]
		description: 'BorderDraggable requires background element to operate.'.
	super initializeElement: anElement.
]

{ #category : #hooks }
OPRTBorderDraggable >> transformDistance: distanceAsPoint forElement: anElement [
	| targetPosition |
	targetPosition := anElement position + distanceAsPoint.
	^ (background encompassingRectangle pointNearestTo: targetPosition) - anElement position
]
