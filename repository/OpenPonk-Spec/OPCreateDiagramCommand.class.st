"
A project tree command that removes the selected domain model element from the project using transactional undo.
"
Class {
	#name : 'OPCreateDiagramCommand',
	#superclass : 'OPProjectTreeCommand',
	#category : 'OpenPonk-Spec-Commands-ProjectTree',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-ProjectTree'
}

{ #category : 'testing' }
OPCreateDiagramCommand >> canBeExecuted [

	^ self selectedViewModel isForRootModel
]

{ #category : 'executing' }
OPCreateDiagramCommand >> execute [

	| viewModel model diagramName diagram |
	viewModel := self selectedViewModel.
	model := viewModel model.
	diagramName := nil.
	[ diagramName := UIManager default request: 'Diagram name: ' initialAnswer: model name title: 'Create new' ] doWhileTrue: [
		diagramName isNotNil and: [ diagramName isEmpty ] ].
	diagramName ifNil: [ ^ self ].
	diagram := OPOpenPonkDiagram forModelElement: model.
	diagram name: diagramName.
	self projectController project addDiagram: diagram.
	self projectController project announcer announce: (OPDiagramAdded diagram: diagram).
	self workbench ifNotNil: [ :activeWorkbench | activeWorkbench openEditorOnDiagram: diagram ]
]

{ #category : 'accessing' }
OPCreateDiagramCommand >> iconName [

	^ #glamorousAdd
]

{ #category : 'initialization' }
OPCreateDiagramCommand >> initialize [

	super initialize.
	self name: 'Create empty diagram'
]
