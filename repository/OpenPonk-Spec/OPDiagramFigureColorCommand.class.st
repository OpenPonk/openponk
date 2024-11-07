Class {
	#name : 'OPDiagramFigureColorCommand',
	#superclass : 'OPDiagramFigureCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'testing' }
OPDiagramFigureColorCommand class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [
		  aToolContext controllers anySatisfy: [ :any |
			  any diagramElement supportsColorChangeOfType: self colorAttribute ] ]
]

{ #category : 'accessing' }
OPDiagramFigureColorCommand class >> color [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPDiagramFigureColorCommand class >> colorAttribute [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPDiagramFigureColorCommand class >> colorFor: aDiagramElement [

	^ self color
]

{ #category : 'accessing' }
OPDiagramFigureColorCommand class >> currentColorOf: aDiagramElement [

	^ aDiagramElement
		  stylePropertyNamed: self colorAttribute
		  ifAbsent: [ self defaultColorOf: aDiagramElement ]
]

{ #category : 'accessing' }
OPDiagramFigureColorCommand class >> defaultColorOf: aDiagramElement [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPDiagramFigureColorCommand class >> defaultColorsOfDiagramElements: diagramElements [

	^ (diagramElements select: [ :each |
		   each supportsColorChangeOfType: self colorAttribute ])
		  collect: [ :each | self defaultColorOf: each ]
		  as: Set
]

{ #category : 'testing' }
OPDiagramFigureColorCommand class >> isAbstract [

	^ self = OPDiagramFigureColorCommand or: [
		  self superclass = OPDiagramFigureColorCommand ]
]

{ #category : 'accessing' }
OPDiagramFigureColorCommand >> color [

	^ self class color
]

{ #category : 'accessing' }
OPDiagramFigureColorCommand >> colorName [

	| colorName |
	colorName := self color name.
	colorName = #unnamed ifTrue: [ ^ '#' , self color asHexString ].
	^ colorName splitCamelCase last capitalized
]

{ #category : 'accessing - defaults' }
OPDiagramFigureColorCommand >> currentColors [

	^ (diagramElements select: [ :each |
		   each supportsColorChangeOfType: self class colorAttribute ])
		  collect: [ :each | self class currentColorOf: each ]
		  as: Set
]

{ #category : 'accessing - defaults' }
OPDiagramFigureColorCommand >> defaultColors [

	^ self class defaultColorsOfDiagramElements: diagramElements
]

{ #category : 'accessing' }
OPDiagramFigureColorCommand >> defaultMenuIconFormSet [

	^ FormSet form: (Morph new
			   color: self color;
			   asFormOfSize: 30 @ 20)
]

{ #category : 'accessing' }
OPDiagramFigureColorCommand >> defaultMenuItemName [

	| isDefault isCurrent |
	isDefault := self defaultColors allSatisfy: [ :each |
		             each = self color ].
	isCurrent := self currentColors allSatisfy: [ :each |
		             each = self color ].
	^ String streamContents: [ :s |
		  s << self colorName.
		  isDefault ifTrue: [ s << ' (default)' ].
		  isCurrent ifTrue: [ s << ' [current]' ] ]
]

{ #category : 'execution' }
OPDiagramFigureColorCommand >> execute [

	diagramElements
		select: [ :each |
		each supportsColorChangeOfType: self class colorAttribute ]
		thenDo: [ :each |
			self executeOn: each ]
]

{ #category : 'execution' }
OPDiagramFigureColorCommand >> executeOn: aDiagramElement [

	aDiagramElement
		stylePropertyNamed: self class colorAttribute
		put: (self class colorFor: aDiagramElement)
]
