Trait {
	#name : 'OPTColoredAsFill',
	#traits : 'OPTColored',
	#classTraits : 'OPTColored classTrait',
	#category : 'OpenPonk-Core-Shapes',
	#package : 'OpenPonk-Core',
	#tag : 'Shapes'
}

{ #category : 'accessing' }
OPTColoredAsFill >> color [

	^ self fillColor
]

{ #category : 'accessing' }
OPTColoredAsFill >> fillColor [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color white ]
]

{ #category : 'accessing' }
OPTColoredAsFill >> fillColor: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]
