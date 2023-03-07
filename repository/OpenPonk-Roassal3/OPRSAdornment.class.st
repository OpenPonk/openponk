Class {
	#name : #OPRSAdornment,
	#superclass : #Object,
	#instVars : [
		'action',
		'icon',
		'shape',
		'padding'
	],
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #'instance creation' }
OPRSAdornment class >> withIconForm: aForm action: aBlock [

	^ self new
		  iconForm: aForm;
		  action: aBlock;
		  yourself
]

{ #category : #'instance creation' }
OPRSAdornment class >> withIconShape: aShape action: aBlock [

	^ self new
		  iconShape: aShape;
		  action: aBlock;
		  yourself
]

{ #category : #accessing }
OPRSAdornment >> action [

	^ action ifNil: [ [ "do nothing" ] ]
]

{ #category : #accessing }
OPRSAdornment >> action: anObject [

	action := anObject
]

{ #category : #accessing }
OPRSAdornment >> icon [

	icon ifNil: [ self iconName: #smallDoIt ].
	^ icon
]

{ #category : #accessing }
OPRSAdornment >> iconForm: aForm [

	self iconShape: (RSBitmap new
			 form: aForm;
			 yourself)
]

{ #category : #accessing }
OPRSAdornment >> iconName: aSymbol [

	self iconForm: (self iconNamed: aSymbol)
]

{ #category : #accessing }
OPRSAdornment >> iconShape: aShape [

	icon := aShape copy
]

{ #category : #initialization }
OPRSAdornment >> initialize [

	super initialize.
	self padding: 3
]

{ #category : #'as yet unclassified' }
OPRSAdornment >> padding: aNumber [

	padding := aNumber
]

{ #category : #'as yet unclassified' }
OPRSAdornment >> remove [

	self shape remove
]

{ #category : #'as yet unclassified' }
OPRSAdornment >> shape [

	| innerBox |
	shape ifNotNil: [ ^ shape ].

	shape := RSBox new.
	shape extent: self icon extent + (padding * 2).
	shape color: Color transparent.

	shape when: RSMouseLeftClick do: self action.

	innerBox := RSBox new.
	innerBox extent: shape extent - 2.
	innerBox color: Color white.
	innerBox borderColor: Color lightGray.

	RSLocation new stick: innerBox on: shape.
	RSLocation new stick: self icon on: innerBox.
	shape when: RSShapeAddedEvent do: [ :event | 
		event canvas
			add: innerBox;
			add: self icon ].
	shape when: RSShapeRemovedEvent do: [ :event | 
		self icon remove.
		innerBox remove ].

	^ shape
]

{ #category : #'as yet unclassified' }
OPRSAdornment >> showOnShape: aShape horizontal: aHorizontalLocation vertical: aVerticalLocation offset: offset [

	self icon model: aShape.
	self shape model: aShape.
	aHorizontalLocation
		offset: offset;
		move: self shape on: aShape.
	aVerticalLocation
		offset: offset + (shape position x - aShape position x @ 0);
		stick: self shape on: aShape.
	self shape
		when: RSShapeRemovedEvent
		do: [ aShape announcer unsubscribe: aVerticalLocation ].
	aShape canvas add: self shape
]
