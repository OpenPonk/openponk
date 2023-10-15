Trait {
	#name : #OPTDIColoredAsFont,
	#traits : 'OPTDIColored',
	#classTraits : 'OPTDIColored classTrait',
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPTDIColoredAsFont >> color [

	^ self fontColor
]

{ #category : #accessing }
OPTDIColoredAsFont >> fontColor [

	^ self stylePropertyNamed: #fontColor ifAbsent: [ Color black ]
]

{ #category : #accessing }
OPTDIColoredAsFont >> fontColor: aColor [

	^ self stylePropertyNamed: #fontColor put: aColor
]
