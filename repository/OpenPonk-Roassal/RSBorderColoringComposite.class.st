Class {
	#name : #RSBorderColoringComposite,
	#superclass : #RSComposite,
	#instVars : [
		'shapesToUseBorderColor',
		'borderColoredShapesColorBlock'
	],
	#category : #'OpenPonk-Roassal-Markers'
}

{ #category : #accessing }
RSBorderColoringComposite >> borderColor: aColor [

	self shapesToUsePaint do: [ :each | each borderColor: aColor ].
	self shapesToUseBorderColor do: [ :each | 
		each color: (borderColoredShapesColorBlock value: aColor) ]
]

{ #category : #accessing }
RSBorderColoringComposite >> color: aColor [

	aColor ifNil: [ ^ super color: aColor ].
	self shapesToUsePaint do: [ :each | each color: aColor ]
]

{ #category : #'as yet unclassified' }
RSBorderColoringComposite >> initialize [

	super initialize.
	shapesToUseBorderColor := IdentitySet new.
	self paintWhiteForTransparentBorder
]

{ #category : #'as yet unclassified' }
RSBorderColoringComposite >> keepPaintTransparencyFromBorder [

	borderColoredShapesColorBlock := #yourself
]

{ #category : #accessing }
RSBorderColoringComposite >> noPaint [

	super noPaint.
	self shapesToUsePaint do: [ :each | each noPaint ]
]

{ #category : #accessing }
RSBorderColoringComposite >> paint: aPaint [

	aPaint ifNil: [ ^ super paint: aPaint ].
	self shapesToUsePaint do: [ :each | each paint: aPaint ]
]

{ #category : #'as yet unclassified' }
RSBorderColoringComposite >> paintWhiteForTransparentBorder [

	borderColoredShapesColorBlock := [ :color | 
	                                 color withTransparencyAsWhite ]
]

{ #category : #'as yet unclassified' }
RSBorderColoringComposite >> removeShape: aShape [

	shapesToUseBorderColor remove: aShape ifAbsent: [  ]
]

{ #category : #'as yet unclassified' }
RSBorderColoringComposite >> shapesToUseBorderColor [

	^ shapesToUseBorderColor
]

{ #category : #'as yet unclassified' }
RSBorderColoringComposite >> shapesToUsePaint [

	^ self shapes difference: self shapesToUseBorderColor
]

{ #category : #'as yet unclassified' }
RSBorderColoringComposite >> useBorderColorAsPaintFor: aShape [

	(self shapes includes: aShape) ifFalse: [ self add: aShape ].
	shapesToUseBorderColor add: aShape
]
