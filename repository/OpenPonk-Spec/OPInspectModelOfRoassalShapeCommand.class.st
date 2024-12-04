Class {
	#name : 'OPInspectModelOfRoassalShapeCommand',
	#superclass : 'OPRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'testing' }
OPInspectModelOfRoassalShapeCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: $i meta for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPInspectModelOfRoassalShapeCommand >> defaultMenuIconName [

	^  #glamorousInspect
]

{ #category : 'accessing' }
OPInspectModelOfRoassalShapeCommand >> defaultMenuItemName [

	| basicName |
	basicName := 'Inspect model'.
	models ifNil: [ ^ basicName ].
	models size = 1 ifTrue: [ ^ basicName ].
	^ GRInflector pluralize: basicName
]

{ #category : 'execution' }
OPInspectModelOfRoassalShapeCommand >> execute [

	models size = 1 ifTrue: [ ^ models anyOne inspect ].
	^ models inspect
]
