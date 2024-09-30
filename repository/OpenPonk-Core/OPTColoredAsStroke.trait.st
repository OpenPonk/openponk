Trait {
	#name : 'OPTColoredAsStroke',
	#traits : 'OPTColored',
	#classTraits : 'OPTColored classTrait',
	#category : 'OpenPonk-Core-Shapes',
	#package : 'OpenPonk-Core',
	#tag : 'Shapes'
}

{ #category : 'accessing' }
OPTColoredAsStroke >> color [

	^ self strokeColor
]

{ #category : 'accessing' }
OPTColoredAsStroke >> strokeColor [

	^ self stylePropertyNamed: #strokeColor ifAbsent: [ Color black ]
]

{ #category : 'accessing' }
OPTColoredAsStroke >> strokeColor: aColor [

	^ self stylePropertyNamed: #strokeColor put: aColor
]
