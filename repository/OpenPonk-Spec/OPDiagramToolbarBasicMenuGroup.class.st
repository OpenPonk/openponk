"
Represents a fundamental grouping of menu items within the diagram toolbar, typically arranging core diagram actions such as undo, redo, and zoom controls.
"
Class {
	#name : 'OPDiagramToolbarBasicMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'testing' }
OPDiagramToolbarBasicMenuGroup >> isInlined [
	^ true
]

{ #category : 'accessing' }
OPDiagramToolbarBasicMenuGroup >> name [
	^ 'Basic actions'
]

{ #category : 'accessing' }
OPDiagramToolbarBasicMenuGroup >> order [
	^ 1
]
