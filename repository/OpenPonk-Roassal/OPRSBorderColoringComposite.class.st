"
Specialized composite Roassal shape designed to manage and synchronize border colors and paint transparency logic across multiple nested child shapes simultaneously.
"
Class {
	#name : 'OPRSBorderColoringComposite',
	#superclass : 'RSComposite',
	#instVars : [
		'shapesToUseBorderColor',
		'borderColoredShapesColorBlock'
	],
	#category : 'OpenPonk-Roassal-Markers',
	#package : 'OpenPonk-Roassal',
	#tag : 'Markers'
}

{ #category : 'border' }
OPRSBorderColoringComposite >> borderColor: aColor [

	self shapesToUsePaint do: [ :each | each borderColor: aColor ].
	self shapesToUseBorderColor do: [ :each | 
		each color: (borderColoredShapesColorBlock value: aColor) ]
]

{ #category : 'accessing' }
OPRSBorderColoringComposite >> color: aColor [

	aColor ifNil: [ ^ super color: aColor ].
	self shapesToUsePaint do: [ :each | each color: aColor ]
]

{ #category : 'initialization' }
OPRSBorderColoringComposite >> initialize [

	super initialize.
	shapesToUseBorderColor := IdentitySet new.
	self paintWhiteForTransparentBorder
]

{ #category : 'modifying' }
OPRSBorderColoringComposite >> keepPaintTransparencyFromBorder [

	borderColoredShapesColorBlock := #yourself
]

{ #category : 'accessing' }
OPRSBorderColoringComposite >> noPaint [

	super noPaint.
	self shapesToUsePaint do: [ :each | each noPaint ]
]

{ #category : 'accessing' }
OPRSBorderColoringComposite >> paint: aPaint [

	aPaint ifNil: [ ^ super paint: aPaint ].
	self shapesToUsePaint do: [ :each | each paint: aPaint ]
]

{ #category : 'modifying' }
OPRSBorderColoringComposite >> paintWhiteForTransparentBorder [

	borderColoredShapesColorBlock := [ :color | 
	                                 color withTransparencyAsWhite ]
]

{ #category : 'removing' }
OPRSBorderColoringComposite >> removeShape: aShape [

	shapesToUseBorderColor remove: aShape ifAbsent: [  ]
]

{ #category : 'accessing' }
OPRSBorderColoringComposite >> shapesToUseBorderColor [

	^ shapesToUseBorderColor
]

{ #category : 'accessing' }
OPRSBorderColoringComposite >> shapesToUsePaint [

	^ self shapes difference: self shapesToUseBorderColor
]

{ #category : 'modifying' }
OPRSBorderColoringComposite >> useBorderColorAsPaintFor: aShape [

	(self shapes includes: aShape) ifFalse: [ self add: aShape ].
	shapesToUseBorderColor add: aShape
]
