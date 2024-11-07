Trait {
	#name : 'OPTColoredAsStroke',
	#traits : 'OPTColored',
	#classTraits : 'OPTColored classTrait',
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPTColoredAsStroke >> color [

	^ self strokeColor
]

{ #category : 'accessing' }
OPTColoredAsStroke >> defaultStrokeColor [

	^ Color black
]

{ #category : 'accessing' }
OPTColoredAsStroke >> strokeColor [

	^ self
		  stylePropertyNamed: #strokeColor
		  ifAbsent: [ self defaultStrokeColor ]
]

{ #category : 'accessing' }
OPTColoredAsStroke >> strokeColor: aColor [

	^ self stylePropertyNamed: #strokeColor put: aColor
]
