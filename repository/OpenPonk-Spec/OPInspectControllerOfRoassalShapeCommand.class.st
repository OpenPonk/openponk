Class {
	#name : 'OPInspectControllerOfRoassalShapeCommand',
	#superclass : 'OPRoassalShapeDevCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'testing' }
OPInspectControllerOfRoassalShapeCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: $i shift meta for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPInspectControllerOfRoassalShapeCommand >> defaultMenuIconName [

	^ #glamorousInspect
]

{ #category : 'accessing' }
OPInspectControllerOfRoassalShapeCommand >> defaultMenuItemName [

	| basicName |
	basicName := 'Inspect controller'.
	controllers ifNil: [ ^ basicName ].
	controllers size = 1 ifTrue: [ ^ basicName ].
	^ GRInflector pluralize: basicName
]

{ #category : 'execution' }
OPInspectControllerOfRoassalShapeCommand >> execute [

	controllers size = 1 ifTrue: [ ^ controllers anyOne inspect ].
	^ controllers inspect
]
