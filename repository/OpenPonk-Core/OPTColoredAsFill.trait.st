"
Trait extending OPTColored to update and manage a color as a fill color.
Used by diagram elements to bind style properties to Roassal shape fill colors.
"
Trait {
	#name : 'OPTColoredAsFill',
	#traits : 'OPTColored',
	#classTraits : 'OPTColored classTrait',
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPTColoredAsFill >> color [

	^ self fillColor
]

{ #category : 'accessing' }
OPTColoredAsFill >> defaultFillColor [

	^ Color white
]

{ #category : 'accessing' }
OPTColoredAsFill >> fillColor [

	^ self
		  stylePropertyNamed: #fillColor
		  ifAbsent: [ self defaultFillColor ]
]

{ #category : 'accessing' }
OPTColoredAsFill >> fillColor: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]
