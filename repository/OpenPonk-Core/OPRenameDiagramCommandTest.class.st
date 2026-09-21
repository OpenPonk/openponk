Class {
	#name : 'OPRenameDiagramCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagram',
		'undoManager'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPRenameDiagramCommandTest >> setUp [
	super setUp.
	undoManager := OPUndoManager new.
	diagram := OPOpenPonkDiagram new.
	diagram name: 'Old Name'
]

{ #category : 'tests' }
OPRenameDiagramCommandTest >> testExecuteRenamesDiagram [
	| cmd |
	cmd := OPRenameDiagramCommand diagram: diagram newName: 'New Name'.
	cmd execute.

	self assert: diagram name equals: 'New Name'
]

{ #category : 'tests' }
OPRenameDiagramCommandTest >> testIntegrationWithUndoManager [
	| cmd |
	cmd := OPRenameDiagramCommand diagram: diagram newName: 'New Name'.
	undoManager execute: cmd.

	self assert: diagram name equals: 'New Name'.

	undoManager undo.
	self assert: diagram name equals: 'Old Name'.

	undoManager redo.
	self assert: diagram name equals: 'New Name'
]

{ #category : 'tests' }
OPRenameDiagramCommandTest >> testRedoReappliesNewName [
	| cmd |
	cmd := OPRenameDiagramCommand diagram: diagram newName: 'New Name'.
	cmd execute.
	cmd undo.
	cmd redo.

	self assert: diagram name equals: 'New Name'
]

{ #category : 'tests' }
OPRenameDiagramCommandTest >> testUndoRestoresOriginalName [
	| cmd |
	cmd := OPRenameDiagramCommand diagram: diagram newName: 'New Name'.
	cmd execute.
	cmd undo.

	self assert: diagram name equals: 'Old Name'
]
