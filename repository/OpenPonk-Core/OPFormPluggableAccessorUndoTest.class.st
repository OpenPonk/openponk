"
Integration test verifying that form fields bound with pluggable accessors without a symbol selector properly record and execute undo/redo without DNU errors.
"
Class {
	#name : 'OPFormPluggableAccessorUndoTest',
	#superclass : 'TestCase',
	#instVars : [
		'undoManager',
		'form',
		'annotation',
		'viewModel'
	],
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'running' }
OPFormPluggableAccessorUndoTest >> setUp [
	super setUp.
	undoManager := OPUndoManager new.
	form := OPPropertiesForm new.
	form undoManager: undoManager.
	annotation := OPFormTestModel new name: 'Original Annotation'.
	viewModel := OPFormPluggableTestViewModel forModel: annotation.
	form viewModel: viewModel
]

{ #category : 'tests' }
OPFormPluggableAccessorUndoTest >> testPluggableAccessorUndoRedo [
	| textBinding textPresenter |
	textBinding := form bindings detect: [ :b | b presenter isKindOf: SpTextPresenter ].
	textPresenter := textBinding presenter.
	self assert: textPresenter text equals: 'Original Annotation'.

	textPresenter text: 'Modified Annotation'.
	self assert: annotation name equals: 'Modified Annotation'.
	self assert: undoManager canUndo.

	undoManager undo.
	self assert: annotation name equals: 'Original Annotation'.
	self assert: textPresenter text equals: 'Original Annotation'.

	undoManager redo.
	self assert: annotation name equals: 'Modified Annotation'.
	self assert: textPresenter text equals: 'Modified Annotation'
]
