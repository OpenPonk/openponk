Trait {
	#name : 'OPTRoassalShapeDefaultColorCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'testing' }
OPTRoassalShapeDefaultColorCommand classSide >> canBeExecutedInContext: aToolContext [

	| defaultColors |
	(super canBeExecutedInContext: aToolContext) ifFalse: [ ^ false ].
	defaultColors := self defaultColorsOfDiagramElements:
		                 aToolContext diagramElements.
	^ defaultColors size > 1 or: [
		  self superclass allSubclasses noneSatisfy: [ :each |
			  each color = defaultColors anyOne ] ]
]

{ #category : 'accessing' }
OPTRoassalShapeDefaultColorCommand classSide >> color [

	^ Color transparent
]

{ #category : 'accessing' }
OPTRoassalShapeDefaultColorCommand classSide >> colorFor: aDiagramElement [

	^ self defaultColorOf: aDiagramElement
]

{ #category : 'accessing' }
OPTRoassalShapeDefaultColorCommand >> color [

	| defaultColors |
	defaultColors := self defaultColors.
	defaultColors size = 1 ifFalse: [ ^ self class color ].
	^ defaultColors anyOne
]

{ #category : 'execution' }
OPTRoassalShapeDefaultColorCommand >> executeOn: aDiagramElement [

	aDiagramElement removeLocalStylePropertyNamed: self class colorAttribute
]
