Class {
	#name : 'OPInspectRoassalShapeCommand',
	#superclass : 'OPRoassalShapeDevCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'accessing' }
OPInspectRoassalShapeCommand >> defaultMenuIconName [

	^ #glamorousInspect
]

{ #category : 'accessing' }
OPInspectRoassalShapeCommand >> defaultMenuItemName [

	| basicName |
	basicName := 'Inspect figure'.
	roassalShapes ifNil: [ ^ basicName ].
	roassalShapes size = 1 ifTrue: [ ^ basicName ].
	^ GRInflector pluralize: basicName
]

{ #category : 'execution' }
OPInspectRoassalShapeCommand >> execute [

	roassalShapes size = 1 ifTrue: [ ^ roassalShapes anyOne inspect ].
	^ roassalShapes inspect
]
