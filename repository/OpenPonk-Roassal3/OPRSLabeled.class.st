Class {
	#name : #OPRSLabeled,
	#superclass : #RSLabeled,
	#instVars : [
		'shape',
		'labelShape'
	],
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #hooks }
OPRSLabeled >> getOrCreateLabel: aShape [

	^ labelShape := super getOrCreateLabel: aShape
]

{ #category : #hooks }
OPRSLabeled >> onShape: aShape [

	shape := aShape.
	super onShape: aShape
]

{ #category : #'public - configuration' }
OPRSLabeled >> text: aText [

	super text: aText.

	self update
]

{ #category : #hooks }
OPRSLabeled >> update [

	labelShape ifNil: [ ^ self ].

	labelShape remove.
	shape announcer unsubscribe: location.
	shape removePropertyAt: #RSLabeled.
	self getOrCreateLabel: shape
]

{ #category : #'public - configuration' }
OPRSLabeled >> wrapMaxWidth: aNumber [

	shapeBuilder wrapStrategy wrapMaxWidth: aNumber.

	self update
]
