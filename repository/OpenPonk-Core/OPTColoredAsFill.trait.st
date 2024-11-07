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
