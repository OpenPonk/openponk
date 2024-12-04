Class {
	#name : 'OPRoassalShapeColorCommand',
	#superclass : 'OPRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'testing' }
OPRoassalShapeColorCommand class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [
		  aToolContext controllers anySatisfy: [ :any |
			  any diagramElement supportsColorChangeOfType: self colorAttribute ] ]
]

{ #category : 'accessing' }
OPRoassalShapeColorCommand class >> color [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPRoassalShapeColorCommand class >> colorAttribute [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPRoassalShapeColorCommand class >> colorFor: aDiagramElement [

	^ self color
]

{ #category : 'accessing' }
OPRoassalShapeColorCommand class >> currentColorOf: aDiagramElement [

	^ aDiagramElement
		  stylePropertyNamed: self colorAttribute
		  ifAbsent: [ self defaultColorOf: aDiagramElement ]
]

{ #category : 'accessing' }
OPRoassalShapeColorCommand class >> defaultColorOf: aDiagramElement [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPRoassalShapeColorCommand class >> defaultColorsOfDiagramElements: diagramElements [

	^ (diagramElements select: [ :each |
		   each supportsColorChangeOfType: self colorAttribute ])
		  collect: [ :each | self defaultColorOf: each ]
		  as: Set
]

{ #category : 'testing' }
OPRoassalShapeColorCommand class >> isAbstract [

	^ self = OPRoassalShapeColorCommand or: [
		  self superclass = OPRoassalShapeColorCommand ]
]

{ #category : 'accessing' }
OPRoassalShapeColorCommand >> color [

	^ self class color
]

{ #category : 'accessing' }
OPRoassalShapeColorCommand >> colorName [

	| colorName |
	colorName := self color name.
	colorName = #unnamed ifTrue: [ ^ '#' , self color asHexString ].
	^ colorName splitCamelCase last capitalized
]

{ #category : 'accessing - defaults' }
OPRoassalShapeColorCommand >> currentColors [

	^ (diagramElements select: [ :each |
		   each supportsColorChangeOfType: self class colorAttribute ])
		  collect: [ :each | self class currentColorOf: each ]
		  as: Set
]

{ #category : 'accessing - defaults' }
OPRoassalShapeColorCommand >> defaultColors [

	^ self class defaultColorsOfDiagramElements: diagramElements
]

{ #category : 'accessing' }
OPRoassalShapeColorCommand >> defaultMenuIconFormSet [

	^ FormSet form: (Morph new
			   color: self color;
			   asFormOfSize: 30 @ 20)
]

{ #category : 'accessing' }
OPRoassalShapeColorCommand >> defaultMenuItemName [

	| isDefault isCurrent |
	isDefault := self defaultColors allSatisfy: [ :each |
		             each = self color ].
	isCurrent := self currentColors allSatisfy: [ :each |
		             each = self color ].
	^ String streamContents: [ :s |
		  s << self colorName.
		  isDefault ifTrue: [ s << ' (default)' ].
		  isCurrent ifTrue: [ s << ' [selected]' ] ]
]

{ #category : 'execution' }
OPRoassalShapeColorCommand >> execute [

	diagramElements
		select: [ :each |
		each supportsColorChangeOfType: self class colorAttribute ]
		thenDo: [ :each |
			self executeOn: each ]
]

{ #category : 'execution' }
OPRoassalShapeColorCommand >> executeOn: aDiagramElement [

	aDiagramElement
		stylePropertyNamed: self class colorAttribute
		put: (self class colorFor: aDiagramElement)
]
