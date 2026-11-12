Class {
	#name : 'OPRemoveModelCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'model',
		'projectController',
		'undoManager',
		'viewModel'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPRemoveModelCommandTest >> setUp [
	super setUp.
	project := OPProject new.
	model := OPTestContainerModel new name: 'TestModel'.
	project addModel: model.
	undoManager := OPUndoManager new.
	projectController := OPProjectController forProject: project.
	projectController instVarNamed: #undoManager put: undoManager.
	viewModel := OPTestContainerViewModel new model: model
]

{ #category : 'running' }
OPRemoveModelCommandTest >> tearDown [

	projectController := nil.
	project := nil.
	model := nil.
	undoManager := nil.
	viewModel := nil.
	super tearDown
]

{ #category : 'tests' }
OPRemoveModelCommandTest >> testCanBeExecutedOnlyOnNonProjectViewModel [
	| command contextStub |
	command := OPRemoveModelCommand new.
	contextStub := Mock new.
	command context: contextStub.

	contextStub stub selectedItem willReturn: OPProjectViewModel new.
	self
		deny: command canBeExecuted
		description: 'OPRemoveModelCommand must not be executable on OPProjectViewModel'.

	contextStub stub selectedItem willReturn: OPViewModel new.
	self
		assert: command canBeExecuted
		description: 'OPRemoveModelCommand should be executable on removable domain viewModel'.

	contextStub stub selectedItem willReturn: nil.
	self
		deny: command canBeExecuted
		description: 'OPRemoveModelCommand must not be executable when selection is nil'
]

{ #category : 'tests' }
OPRemoveModelCommandTest >> testExecuteRemovesModelElementAndCanUndo [
	| command contextStub |
	command := OPRemoveModelCommand new.
	contextStub := Mock new.
	command context: contextStub.
	contextStub stub projectController willReturn: projectController.
	contextStub stub selectedItem willReturn: viewModel.

	command execute.
	self denyCollection: project models includesAny: { model }.
	self
		assert: undoManager canUndo
		description: 'Executing OPRemoveModelCommand should record an undoable command'
]
