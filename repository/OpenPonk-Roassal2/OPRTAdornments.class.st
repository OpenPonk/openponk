"
I add icons to the side of a roassal element that have actions associated with them.

See OPRTExamples>>exampleAdornments
"
Class {
	#name : #OPRTAdornments,
	#superclass : #RTInteraction,
	#instVars : [
		'adornments',
		'shapesCache'
	],
	#category : #'OpenPonk-Roassal2-Interactivity'
}

{ #category : #accessing }
OPRTAdornments >> adornments [
	^ adornments value
]

{ #category : #accessing }
OPRTAdornments >> adornments: aListOrBlock [
	adornments := aListOrBlock
]

{ #category : #adornments }
OPRTAdornments >> createAdornmentFrom: anAssociation position: aPosition on: anElement [
	| box icon size |
	size := 20.
	box := RTBox new
		size: size;
		color: Color transparent;
		borderColor: Color black;
		element.
	(RTConstraint on: box background: anElement)
		top;
		right;
		outer;
		verticalPadding: (size * aPosition) negated;
		stick.
	icon := RTBitmap new
		form: anAssociation key;
		element.
	(RTConstraint on: icon background: box) stick.
	box addCallback: (TRAddedCallback block: [ box view add: icon ]).
	box addCallback: (TRRemoveCallback block: [ icon remove ]).
	^ box
]

{ #category : #adornments }
OPRTAdornments >> hideAdornmentsOn: anElement [
	(anElement hasAttribute: self className)
		ifFalse: [ ^ self ].
	(anElement attributeAt: self className)
		do: [ :each | 
			each announcer unsubscribe: each view.
			each announcer unsubscribe: self.
			each remove ].
	anElement removeAttributeAt: self className.
	anElement view signalUpdate
]

{ #category : #initialization }
OPRTAdornments >> initialize [
	super initialize.
	shapesCache := Dictionary new
]

{ #category : #initialization }
OPRTAdornments >> initializeElement: anElement [
	anElement when: OPTRFocused do: [ :e | self showAdornmentsOn: anElement ].
	anElement when: OPTRUnfocused do: [ :e | self hideAdornmentsOn: anElement ]
]

{ #category : #adornments }
OPRTAdornments >> shapesCache [
	^ shapesCache
]

{ #category : #adornments }
OPRTAdornments >> showAdornmentsOn: anElement [
	| boxes |
	boxes := self adornments
		withIndexCollect: [ :each :i | 
			| box |
			box := self shapesCache
				at: each
				ifAbsentPut: [ self createAdornmentFrom: each position: i on: anElement ].
			box when: TRMouseLeftClick do: [ :evt | each value value ] ].
	anElement attributeAt: self className put: boxes.
	anElement view addAll: boxes.
	anElement view signalUpdate
]
