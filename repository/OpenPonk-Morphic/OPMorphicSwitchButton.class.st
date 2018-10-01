Class {
	#name : #OPMorphicSwitchButton,
	#superclass : #BorderedMorph,
	#instVars : [
		'label',
		'enabled',
		'onChangeBlock'
	],
	#category : #'OpenPonk-Morphic'
}

{ #category : #drawing }
OPMorphicSwitchButton >> drawOn: aCanvas [
	| boxSize |
	super drawOn: aCanvas.
	aCanvas
		fillRectangle: ((0 @ 0 corner: self size) translateBy: self bounds topLeft)
		fillStyle: self switchThumbColor
		borderStyle: self borderStyle.
	boxSize := (0 @ 0 corner: self size y @ self size y) expandBy: -2 @ -2.
	boxSize := boxSize translateBy: self bounds topLeft.
	enabled
		ifTrue: [ boxSize := boxSize translateBy: (self size x - self size y) @ 0 ].
	aCanvas fillRectangle: boxSize fillStyle: self switchColor borderStyle: self borderStyle
]

{ #category : #accessing }
OPMorphicSwitchButton >> enabled: aBoolean [
	enabled := aBoolean
]

{ #category : #'event handling' }
OPMorphicSwitchButton >> handlesMouseDown: evt [
	^ true
]

{ #category : #initialization }
OPMorphicSwitchButton >> initialize [
	super initialize.
	enabled := false.
	self extent: self size.
	color := Color white.
	onChangeBlock := [ :b |  ]
]

{ #category : #'event handling' }
OPMorphicSwitchButton >> mouseDown: event [
	self toggle.
	self changed
]

{ #category : #initialization }
OPMorphicSwitchButton >> size [
	^ 60 @ 17
]

{ #category : #drawing }
OPMorphicSwitchButton >> switchColor [
	^ enabled
		ifTrue: [ Color white ]
		ifFalse: [ Color white ]
]

{ #category : #drawing }
OPMorphicSwitchButton >> switchThumbColor [
	^ enabled
		ifTrue: [ Color green muchDarker alpha: 0.5 ]
		ifFalse: [ Color veryVeryLightGray ]
]

{ #category : #actions }
OPMorphicSwitchButton >> toggle [
	enabled := enabled not.
	onChangeBlock value: enabled
]

{ #category : #'event handling' }
OPMorphicSwitchButton >> whenChangedDo: aOneArgBlock [
	onChangeBlock := aOneArgBlock
]
