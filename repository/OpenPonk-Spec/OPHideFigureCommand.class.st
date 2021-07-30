Class {
	#name : #OPHideFigureCommand,
	#superclass : #OPToggleFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPHideFigureCommand class >> canBeExecutedInModelContext: aToolContext [
	^ aToolContext controller isHideable
]

{ #category : #testing }
OPHideFigureCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: $h meta for: OPCanvasPresenter
]

{ #category : #execution }
OPHideFigureCommand >> basicExecute [
	executor hideElements: models
]
