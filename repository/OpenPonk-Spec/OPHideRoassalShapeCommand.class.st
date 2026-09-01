"
Context menu command that explicitly hides the selected Roassal shape from the active diagram canvas.
"
Class {
	#name : 'OPHideRoassalShapeCommand',
	#superclass : 'OPToggleRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'testing' }
OPHideRoassalShapeCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: $h meta for: OPCanvasPresenter
]

{ #category : 'execution' }
OPHideRoassalShapeCommand >> basicExecute [

	executor hideElements:
		(controllers select: #isHideable thenCollect: #model)
]
