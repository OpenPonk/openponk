Class {
	#name : 'OPDiagramsListTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagram',
		'listPresenter',
		'project',
		'undoManager'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPDiagramsListTest >> setUp [
	super setUp.
	undoManager := OPUndoManager new.
	project := OPProject new.
	diagram := OPOpenPonkDiagram new.
	diagram name: 'Original Diagram'.
	project addDiagram: diagram.

	listPresenter := OPDiagramsList new.
	listPresenter undoManager: undoManager.
	listPresenter project: project
]

{ #category : 'tests' }
OPDiagramsListTest >> testRenameDiagramRedoReappliesNewNameAndUpdatesList [
	listPresenter renameDiagram: diagram to: 'Renamed Diagram'.
	undoManager undo.
	undoManager redo.

	self assert: diagram name equals: 'Renamed Diagram'.
	self assert: ((listPresenter list items collect: #name) includes: 'Renamed Diagram')
]

{ #category : 'tests' }
OPDiagramsListTest >> testRenameDiagramToExecutesTransaction [
	listPresenter renameDiagram: diagram to: 'Renamed Diagram'.

	self assert: diagram name equals: 'Renamed Diagram'.
	self assert: ((listPresenter list items collect: #name) includes: 'Renamed Diagram')
]

{ #category : 'tests' }
OPDiagramsListTest >> testRenameDiagramUndoRestoresOriginalNameAndUpdatesList [
	listPresenter renameDiagram: diagram to: 'Renamed Diagram'.
	undoManager undo.

	self assert: diagram name equals: 'Original Diagram'.
	self assert: ((listPresenter list items collect: #name) includes: 'Original Diagram')
]
