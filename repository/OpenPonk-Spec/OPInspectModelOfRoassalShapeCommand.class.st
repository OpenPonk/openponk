"
Context menu command that opens a Pharo inspector directly on the underlying domain model of the currently selected Roassal shape.
"
Class {
	#name : 'OPInspectModelOfRoassalShapeCommand',
	#superclass : 'OPRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
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
