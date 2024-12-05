Class {
	#name : 'OPHideRoassalShapeCommand',
	#superclass : 'OPToggleRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
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
