Class {
	#name : 'OPShapeStyle',
	#superclass : 'Object',
	#instVars : [
		'styledElements',
		'properties'
	],
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'testing' }
OPShapeStyle class >> isAbstract [
	^ self = OPShapeStyle
]

{ #category : 'accessing' }
OPShapeStyle >> addedAsLocalToStyledElement: aDiagramElement [

	aDiagramElement localStyle = self ifFalse: [ 
		'This style was not added as local style to the element' ].
	styledElements ifNotEmpty: [ 
		self error: 'Cannot use style as local if already used elsewhere' ].
	styledElements add: aDiagramElement
]

{ #category : 'accessing' }
OPShapeStyle >> addedAsSharedToStyledElement: aDiagramElement [

	aDiagramElement sharedStyle = self ifFalse: [ 
		'This style was not added as shared style to the element' ].
	(styledElements size = 1 and: [ 
		 styledElements anyOne localStyle == self ]) ifTrue: [ 
		self error: 'Cannot use style as shared if already used as local' ].
	styledElements add: aDiagramElement
]

{ #category : 'accessing' }
OPShapeStyle >> at: aSymbol [

	^ properties at: aSymbol
]

{ #category : 'accessing' }
OPShapeStyle >> at: aSymbol ifAbsent: aBlock [

	^ properties at: aSymbol ifAbsent: aBlock
]

{ #category : 'accessing' }
OPShapeStyle >> at: aSymbol ifPresent: aBlock [

	^ properties at: aSymbol ifPresent: aBlock
]

{ #category : 'accessing' }
OPShapeStyle >> at: aSymbol put: aValue [

	properties at: aSymbol put: aValue.
	self styledElements do: #styleChanged
]

{ #category : 'initialization' }
OPShapeStyle >> initialize [

	super initialize.
	styledElements := Set new.
	properties := Dictionary new
]

{ #category : 'removing' }
OPShapeStyle >> removeKey: aSymbol [

	| result |
	result := properties removeKey: aSymbol.
	self styledElements do: #styleChanged.
	^ result
]

{ #category : 'removing' }
OPShapeStyle >> removeKey: aSymbol ifAbsent: aBlock [

	| result |
	result := properties removeKey: aSymbol ifAbsent: [ ^ aBlock value ].
	self styledElements do: #styleChanged.
	^ result
]

{ #category : 'accessing' }
OPShapeStyle >> removedFromStyledElement: aDiagramElement [

	styledElements remove: aDiagramElement
]

{ #category : 'accessing' }
OPShapeStyle >> styledElements [

	^ styledElements
]
