Class {
	#name : #OPRSSelectionEndEvent,
	#superclass : #RSSelectionEndEvent,
	#instVars : [
		'originalEvent'
	],
	#category : #'OpenPonk-Roassal3'
}

{ #category : #accessing }
OPRSSelectionEndEvent >> originalEvent [

	^ originalEvent
]

{ #category : #accessing }
OPRSSelectionEndEvent >> originalEvent: anObject [

	originalEvent := anObject
]
