"
Trait extending OPTColored to update and manage a color as a font color.
Used by textual diagram elements to bind style properties to Roassal shape text colors.
"
Trait {
	#name : 'OPTColoredAsFont',
	#traits : 'OPTColored',
	#classTraits : 'OPTColored classTrait',
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPTColoredAsFont >> color [

	^ self fontColor
]

{ #category : 'accessing' }
OPTColoredAsFont >> defaultFontColor [

	^ Color black
]

{ #category : 'accessing' }
OPTColoredAsFont >> fontColor [

	^ self
		  stylePropertyNamed: #fontColor
		  ifAbsent: [ self defaultFontColor ]
]

{ #category : 'accessing' }
OPTColoredAsFont >> fontColor: aColor [

	^ self stylePropertyNamed: #fontColor put: aColor
]
