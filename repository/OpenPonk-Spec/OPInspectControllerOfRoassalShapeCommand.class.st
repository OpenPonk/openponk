"
Developer-oriented context menu command that opens a Pharo inspector directly on the controller managing the selected Roassal shape.
"
Class {
	#name : 'OPInspectControllerOfRoassalShapeCommand',
	#superclass : 'OPInspectDevCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'testing' }
OPInspectControllerOfRoassalShapeCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: $i shift meta for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPInspectControllerOfRoassalShapeCommand >> itemType [

	^ 'controller'
]

{ #category : 'accessing' }
OPInspectControllerOfRoassalShapeCommand >> items [

	^ controllers
]
