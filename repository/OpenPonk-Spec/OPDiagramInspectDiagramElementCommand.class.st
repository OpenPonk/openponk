Class {
	#name : 'OPDiagramInspectDiagramElementCommand',
	#superclass : 'OPDiagramFigureDevCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'accessing' }
OPDiagramInspectDiagramElementCommand >> defaultMenuIcon [

	^ self iconNamed: #glamorousInspect
]

{ #category : 'accessing' }
OPDiagramInspectDiagramElementCommand >> defaultMenuItemName [

	| basicName |
	basicName := 'Inspect diagram element'.
	diagramElements ifNil: [ ^ basicName ].
	diagramElements size = 1 ifTrue: [ ^ basicName ].
	^ GRInflector pluralize: basicName
]

{ #category : 'execution' }
OPDiagramInspectDiagramElementCommand >> execute [

	diagramElements size = 1 ifTrue: [ ^ diagramElements anyOne inspect ].
	^ diagramElements inspect
]
