"
Event announced when a selection operation (like a lasso drag) concludes. 
Wraps the original interaction event that triggered the end of the selection phase.
"
Class {
	#name : 'OPRSSelectionEndEvent',
	#superclass : 'RSSelectionEndEvent',
	#instVars : [
		'originalEvent'
	],
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'accessing' }
OPRSSelectionEndEvent >> originalEvent [

	^ originalEvent
]

{ #category : 'accessing' }
OPRSSelectionEndEvent >> originalEvent: anObject [

	originalEvent := anObject
]
