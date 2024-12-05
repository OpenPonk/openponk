Class {
	#name : 'OPInspectDiagramElementCommand',
	#superclass : 'OPRoassalShapeDevCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'accessing' }
OPInspectDiagramElementCommand >> defaultMenuIconName [

	^ #glamorousInspect
]

{ #category : 'accessing' }
OPInspectDiagramElementCommand >> defaultMenuItemName [

	| basicName |
	basicName := 'Inspect diagram element'.
	diagramElements ifNil: [ ^ basicName ].
	diagramElements size = 1 ifTrue: [ ^ basicName ].
	^ GRInflector pluralize: basicName
]

{ #category : 'execution' }
OPInspectDiagramElementCommand >> execute [

	diagramElements size = 1 ifTrue: [ ^ diagramElements anyOne inspect ].
	^ diagramElements inspect
]
