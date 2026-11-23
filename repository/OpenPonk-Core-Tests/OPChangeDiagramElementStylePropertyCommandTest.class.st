"
Unit tests verifying execution, undo, redo, and local style restoration for diagram element style property commands.
"
Class {
	#name : 'OPChangeDiagramElementStylePropertyCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'undoManager',
		'node'
	],
	#category : 'OpenPonk-Core-Tests-UndoRedo',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'UndoRedo'
}

{ #category : 'running' }
OPChangeDiagramElementStylePropertyCommandTest >> setUp [

	super setUp.
	undoManager := OPUndoManager new.
	node := OPTestBoundNode new
]

{ #category : 'tests' }
OPChangeDiagramElementStylePropertyCommandTest >> testExecuteUndoRedoExistingLocalProperty [

	| command |
	node stylePropertyNamed: #fillColor put: Color blue.
	command := OPChangeDiagramElementStylePropertyCommand element: node property: #fillColor value: Color green.

	self assert: command oldValue equals: Color blue.
	self assert: command newValue equals: Color green.

	undoManager execute: command.
	self assert: (node stylePropertyNamed: #fillColor ifAbsent: [ nil ]) equals: Color green.

	undoManager undo.
	self assert: (node stylePropertyNamed: #fillColor ifAbsent: [ nil ]) equals: Color blue.

	undoManager redo.
	self assert: (node stylePropertyNamed: #fillColor ifAbsent: [ nil ]) equals: Color green
]

{ #category : 'tests' }
OPChangeDiagramElementStylePropertyCommandTest >> testExecuteUndoRedoNewLocalProperty [

	| command |
	command := OPChangeDiagramElementStylePropertyCommand element: node property: #fillColor value: Color red.

	self assert: command element identicalTo: node.
	self assert: command property equals: #fillColor.
	self assert: command oldValue identicalTo: nil.
	self assert: command newValue equals: Color red.

	undoManager execute: command.
	self assert: (node stylePropertyNamed: #fillColor ifAbsent: [ nil ]) equals: Color red.

	undoManager undo.
	self assert: (node stylePropertyNamed: #fillColor ifAbsent: [ nil ]) identicalTo: nil.

	undoManager redo.
	self assert: (node stylePropertyNamed: #fillColor ifAbsent: [ nil ]) equals: Color red
]

{ #category : 'tests' }
OPChangeDiagramElementStylePropertyCommandTest >> testExecuteWithNilValueRemovesLocalPropertyAndUndoRestoresIt [

	| command |
	node stylePropertyNamed: #strokeColor put: Color black.
	command := OPChangeDiagramElementStylePropertyCommand element: node property: #strokeColor value: nil.

	undoManager execute: command.
	self assert: (node stylePropertyNamed: #strokeColor ifAbsent: [ #missing ]) equals: #missing.

	undoManager undo.
	self assert: (node stylePropertyNamed: #strokeColor ifAbsent: [ nil ]) equals: Color black
]
