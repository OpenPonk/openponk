Class {
	#name : #OPRSAdornmentBuilder,
	#superclass : #Object,
	#instVars : [
		'adornments',
		'direction',
		'verticalLocation',
		'horizontalLocation'
	],
	#category : #'OpenPonk-Roassal-Interactions'
}

{ #category : #adding }
OPRSAdornmentBuilder >> addIconForm: anIcon action: aBlock [

	adornments add: (OPRSAdornment withIconForm: anIcon action: aBlock)
]

{ #category : #adding }
OPRSAdornmentBuilder >> addIconShape: aShape action: aBlock [

	adornments add: (OPRSAdornment withIconShape: aShape action: aBlock)
]

{ #category : #initialization }
OPRSAdornmentBuilder >> directionDown [

	direction := 0 @ 1
]

{ #category : #initialization }
OPRSAdornmentBuilder >> directionLeft [

	direction := -1 @ 0
]

{ #category : #initialization }
OPRSAdornmentBuilder >> directionRight [

	direction := 1 @ 0
]

{ #category : #initialization }
OPRSAdornmentBuilder >> directionUp [

	direction := 0 @ -1
]

{ #category : #initialization }
OPRSAdornmentBuilder >> hide [

	adornments do: #remove
]

{ #category : #initialization }
OPRSAdornmentBuilder >> horizontalLocation [

	^ horizontalLocation
]

{ #category : #initialization }
OPRSAdornmentBuilder >> initialize [

	super initialize.
	verticalLocation := RSLocation new
		                    inner;
		                    top;
		                    yourself.
	horizontalLocation := RSLocation new
		                      outer;
		                      right;
		                      yourself.
	self directionDown.
	adornments := RSGroup new
]

{ #category : #initialization }
OPRSAdornmentBuilder >> showOn: aShape [

	adornments inject: 0 @ 0 into: [ :offset :eachAdornment |
		eachAdornment
			showOnShape: aShape
			horizontal: self horizontalLocation copy
			vertical: self verticalLocation copy
			offset: offset.
		offset + (eachAdornment shape extentWithoutBorder * direction) ]
]

{ #category : #initialization }
OPRSAdornmentBuilder >> verticalLocation [

	^ verticalLocation
]
