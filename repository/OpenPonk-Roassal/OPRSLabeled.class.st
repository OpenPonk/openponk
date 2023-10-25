Class {
	#name : #OPRSLabeled,
	#superclass : #RSLabeled,
	#instVars : [
		'shape',
		'labelShape'
	],
	#category : #'OpenPonk-Roassal-Interactions'
}

{ #category : #accessing }
OPRSLabeled >> color: aColor [

	self shapeBuilder labelShape color: aColor
]

{ #category : #accessing }
OPRSLabeled >> emphasis: aTextEmphasis [

	self shapeBuilder labelShape emphasis: aTextEmphasis
]

{ #category : #accessing }
OPRSLabeled >> fontName: aString [

	self shapeBuilder labelShape fontName: aString
]

{ #category : #hooks }
OPRSLabeled >> getOrCreateLabel: aShape [

	^ labelShape := super getOrCreateLabel: aShape
]

{ #category : #accessing }
OPRSLabeled >> labelShape [

	^ labelShape
]

{ #category : #hooks }
OPRSLabeled >> onShape: aShape [

	shape := aShape.
	super onShape: aShape
]

{ #category : #'public - configuration' }
OPRSLabeled >> text: aText [

	super text: aText asString.

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
