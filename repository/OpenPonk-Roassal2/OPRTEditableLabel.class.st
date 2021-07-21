"
DCRTEditableLabel is a modification of Roassal's RTEditableLabel with the added support for raw Rubric events. (Namely rawKeystroke).
"
Class {
	#name : #OPRTEditableLabel,
	#superclass : #RTEditableLabel,
	#instVars : [
		'rawEvents'
	],
	#category : 'OpenPonk-Roassal2-Shapes'
}

{ #category : #initialization }
OPRTEditableLabel >> initialize [
	super initialize.
	rawEvents := OrderedCollection new
]

{ #category : #events }
OPRTEditableLabel >> onRawKeystroke: aBlock [
	rawEvents add: RubKeystroke -> aBlock
]

{ #category : #rendering }
OPRTEditableLabel >> showTextMorphFor: anElement [
	super showTextMorphFor: anElement.
	rawEvents do: [ :pair | fieldArea announcer subscribe: pair key send: #value: to: pair value ]
]
