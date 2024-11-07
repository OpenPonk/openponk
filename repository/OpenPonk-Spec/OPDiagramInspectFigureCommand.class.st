Class {
	#name : 'OPDiagramInspectFigureCommand',
	#superclass : 'OPDiagramFigureDevCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'accessing' }
OPDiagramInspectFigureCommand >> defaultMenuIcon [

	^ self iconNamed: #glamorousInspect
]

{ #category : 'accessing' }
OPDiagramInspectFigureCommand >> defaultMenuItemName [

	| basicName |
	basicName := 'Inspect figure'.
	figures ifNil: [ ^ basicName ].
	figures size = 1 ifTrue: [ ^ basicName ].
	^ GRInflector pluralize: basicName
]

{ #category : 'execution' }
OPDiagramInspectFigureCommand >> execute [

	figures size = 1 ifTrue: [ ^ figures anyOne inspect ].
	^ figures inspect
]
