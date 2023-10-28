Trait {
	#name : #OPTColoredAsFont,
	#traits : 'OPTColored',
	#classTraits : 'OPTColored classTrait',
	#category : #'OpenPonk-Core-Shapes'
}

{ #category : #accessing }
OPTColoredAsFont >> color [

	^ self fontColor
]

{ #category : #accessing }
OPTColoredAsFont >> fontColor [

	^ self stylePropertyNamed: #fontColor ifAbsent: [ Color black ]
]

{ #category : #accessing }
OPTColoredAsFont >> fontColor: aColor [

	^ self stylePropertyNamed: #fontColor put: aColor
]
