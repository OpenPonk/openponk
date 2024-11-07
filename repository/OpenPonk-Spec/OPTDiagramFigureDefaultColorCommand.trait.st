Trait {
	#name : 'OPTDiagramFigureDefaultColorCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'testing' }
OPTDiagramFigureDefaultColorCommand classSide >> canBeExecutedInContext: aToolContext [

	| defaultColors |
	(super canBeExecutedInContext: aToolContext) ifFalse: [ ^ false ].
	defaultColors := self defaultColorsOfDiagramElements:
		                 aToolContext diagramElements.
	^ defaultColors size > 1 or: [
		  self superclass allSubclasses noneSatisfy: [ :each |
			  each color = defaultColors anyOne ] ]
]

{ #category : 'accessing' }
OPTDiagramFigureDefaultColorCommand classSide >> color [

	^ Color transparent
]

{ #category : 'accessing' }
OPTDiagramFigureDefaultColorCommand classSide >> colorFor: aDiagramElement [

	^ self defaultColorOf: aDiagramElement
]

{ #category : 'accessing' }
OPTDiagramFigureDefaultColorCommand >> color [

	| defaultColors |
	defaultColors := self defaultColors.
	defaultColors size = 1 ifFalse: [ ^ self class color ].
	^ defaultColors anyOne
]

{ #category : 'execution' }
OPTDiagramFigureDefaultColorCommand >> executeOn: aDiagramElement [

	aDiagramElement removeStylePropertyNamed: self class colorAttribute
]
