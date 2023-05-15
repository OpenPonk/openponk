Class {
	#name : #OPHideFigureCommand,
	#superclass : #OPToggleFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPHideFigureCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: $h meta for: OPCanvasPresenter
]

{ #category : #execution }
OPHideFigureCommand >> basicExecute [

	executor hideElements:
		(controllers select: #isHideable thenCollect: #model)
]
