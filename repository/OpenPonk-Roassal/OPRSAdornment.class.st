Class {
	#name : 'OPRSAdornment',
	#superclass : 'Object',
	#instVars : [
		'action',
		'icon',
		'shape',
		'padding'
	],
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'instance creation' }
OPRSAdornment class >> withIconForm: aForm action: aBlock [

	^ self new
		  iconForm: aForm;
		  action: aBlock;
		  yourself
]

{ #category : 'instance creation' }
OPRSAdornment class >> withIconShape: aShape action: aBlock [

	^ self new
		  iconShape: aShape;
		  action: aBlock;
		  yourself
]

{ #category : 'accessing' }
OPRSAdornment >> action [

	^ action ifNil: [ [ "do nothing" ] ]
]

{ #category : 'accessing' }
OPRSAdornment >> action: anObject [

	action := anObject
]

{ #category : 'accessing' }
OPRSAdornment >> icon [

	icon ifNil: [ self iconName: #smallDoIt ].
	^ icon
]

{ #category : 'accessing' }
OPRSAdornment >> iconForm: aForm [

	self iconShape: (RSBitmap new
			 form: aForm;
			 yourself)
]

{ #category : 'accessing' }
OPRSAdornment >> iconName: aSymbol [

	self iconForm: (self iconNamed: aSymbol)
]

{ #category : 'accessing' }
OPRSAdornment >> iconShape: aShape [

	icon := aShape copy
]

{ #category : 'initialization' }
OPRSAdornment >> initialize [

	super initialize.
	self padding: 2
]

{ #category : 'as yet unclassified' }
OPRSAdornment >> padding: aNumber [

	padding := aNumber
]

{ #category : 'as yet unclassified' }
OPRSAdornment >> remove [

	self shape remove
]

{ #category : 'as yet unclassified' }
OPRSAdornment >> shape [

	| innerBox |
	shape ifNotNil: [ ^ shape ].

	shape := RSBox new.
	shape extent: self icon extent + (padding * 2).
	shape color: Color white.
	shape borderColor: Color lightGray.

	shape
		when: RSMouseLeftClick
		do: self action
		for: self action receiver.

	RSLocation new stick: self icon on: shape.
	shape
		when: RSShapeAddedEvent
		do: [ :event | event canvas add: self icon ]
		for: self.
	shape
		when: RSShapeRemovedEvent
		do: [ :event | self icon remove ]
		for: self.

	^ shape
]

{ #category : 'as yet unclassified' }
OPRSAdornment >> showOnShape: anOriginalShape horizontal: aHorizontalLocation vertical: aVerticalLocation offset: offset [

	| updateBlock |
	self icon model: anOriginalShape.
	self shape model: anOriginalShape.
	updateBlock := [
	               aVerticalLocation
		               offset: 0 @ offset y;
		               move: self shape on: anOriginalShape.
	               aHorizontalLocation
		               offset:
			               offset x
			               @ (shape position y - anOriginalShape position y);
		               move: self shape on: anOriginalShape ].
	anOriginalShape
		when: RSPositionChangedEvent do: updateBlock for: self;
		when: RSExtentChangedEvent do: updateBlock for: self.
	updateBlock value.

	anOriginalShape
		when: RSShapeRemovedEvent
		do: [ self remove ]
		for: self.
	self shape
		when: RSShapeRemovedEvent
		do: [ anOriginalShape announcer unsubscribe: self ]
		for: self.
	anOriginalShape canvas add: self shape
]
