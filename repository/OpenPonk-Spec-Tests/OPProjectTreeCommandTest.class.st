"
Tests contextual project tree command execution and hierarchy updates in the project browser.
"
Class {
	#name : 'OPProjectTreeCommandTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Commands-ProjectTree',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Commands-ProjectTree'
}

{ #category : 'tests' }
OPProjectTreeCommandTest >> testBaseProjectTreeCommandDefaultIconNameIsNil [

	self assert: OPProjectTreeCommand new iconName identicalTo: nil
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testCreateDiagramCommandCanBeExecuted [

	| project container entity projectController command contextStub |
	project := OPProject named: 'Test Project'.
	container := OPTestContainerModel new
		             name: 'Container';
		             yourself.
	entity := OPTestEntityModel new
		          name: 'Entity';
		          yourself.
	container add: entity.
	project addModel: container.
	projectController := OPProjectController forProject: project.

	command := OPCreateDiagramCommand new.
	contextStub := Mock new.
	command context: contextStub.

	contextStub stub selectedItem willReturn: nil.
	self deny: command canBeExecuted description: 'OPCreateDiagramCommand must not be executable when selection is nil'.

	contextStub stub selectedItem willReturn: (projectController viewModelRegistry viewModelFor: entity).
	self deny: command canBeExecuted description: 'OPCreateDiagramCommand must not be executable on a non-root model viewModel'.

	contextStub stub selectedItem willReturn: (projectController viewModelRegistry viewModelFor: container).
	self assert: command canBeExecuted description: 'OPCreateDiagramCommand should be executable on a root model viewModel'
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testCreateDiagramCommandExecuteCancelledDoesNotAddDiagram [

	| project container projectController viewModel command contextStub uiManager |
	project := OPProject named: 'Test Project'.
	container := OPTestContainerModel new
		             name: 'Container';
		             yourself.
	project addModel: container.
	projectController := OPProjectController forProject: project.
	viewModel := projectController viewModelRegistry viewModelFor: container.

	command := OPCreateDiagramCommand new.
	contextStub := Mock new.
	contextStub stub selectedItem willReturn: viewModel.
	contextStub stub projectController willReturn: projectController.
	contextStub stub workbench willReturn: nil.
	command context: contextStub.

	uiManager := UIManager default.
	(uiManager stub request: 'Diagram name: ' initialAnswer: 'Container' title: 'Create new') willReturn: nil.
	[
		command execute.
		self assertEmpty: project diagrams ] ensure: [ uiManager recoverFromGHMutation ]
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testCreateDiagramCommandExecuteRetriesEmptyNameAndOpensEditor [

	| project container projectController viewModel command contextStub workbenchStub uiManager responses announcedDiagrams createdDiagram |
	project := OPProject named: 'Test Project'.
	container := OPTestContainerModel new
		             name: 'Container';
		             yourself.
	project addModel: container.
	projectController := OPProjectController forProject: project.
	viewModel := projectController viewModelRegistry viewModelFor: container.
	announcedDiagrams := OrderedCollection new.
	project announcer when: OPDiagramAdded do: [ :announcement | announcedDiagrams add: announcement diagram ] for: self.

	workbenchStub := Mock new.
	workbenchStub stub openEditorOnDiagram: Any.

	command := OPCreateDiagramCommand new.
	contextStub := Mock new.
	contextStub stub selectedItem willReturn: viewModel.
	contextStub stub projectController willReturn: projectController.
	contextStub stub workbench willReturn: workbenchStub.
	command context: contextStub.

	responses := OrderedCollection with: '' with: 'New Diagram'.
	uiManager := UIManager default.
	(uiManager stub request: 'Diagram name: ' initialAnswer: 'Container' title: 'Create new') will: [ responses removeFirst ].
	[
		command execute.
		self assert: project diagrams size equals: 1.
		createdDiagram := project diagrams first.
		self assert: createdDiagram name equals: 'New Diagram'.
		self assert: createdDiagram modelElement identicalTo: container.
		self assertCollection: announcedDiagrams hasSameElements: { createdDiagram }.
		workbenchStub should receive openEditorOnDiagram: createdDiagram ] ensure: [
			uiManager recoverFromGHMutation.
			project announcer unsubscribe: self ]
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testCreateDiagramCommandHasAddIcon [

	| createCommand specCommand |
	createCommand := OPCreateDiagramCommand new.
	specCommand := createCommand asSpecCommand.
	self assert: specCommand iconName equals: #glamorousAdd
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testInspectModelAndViewModelCommandsExecute [

	| model viewModel contextStub inspectModelCommand inspectViewModelCommand |
	model := Mock new.
	model stub inspect willReturn: model.
	viewModel := Mock new.
	viewModel stub model willReturn: model.
	viewModel stub inspect willReturn: viewModel.

	contextStub := Mock new.
	contextStub stub selectedItem willReturn: viewModel.

	inspectModelCommand := OPInspectModelCommand new.
	inspectModelCommand context: contextStub.
	inspectModelCommand execute.
	model should receive inspect.

	inspectViewModelCommand := OPInspectViewModelCommand new.
	inspectViewModelCommand context: contextStub.
	inspectViewModelCommand execute.
	viewModel should receive inspect
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testInspectModelCommandHasInspectIcon [
	| inspectCommand specCommand |
	inspectCommand := OPInspectModelCommand new.
	specCommand := inspectCommand asSpecCommand.
	self assert: specCommand iconName equals: #glamorousInspect
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testInspectViewModelCommandHasInspectIcon [
	| inspectCommand specCommand |
	inspectCommand := OPInspectViewModelCommand new.
	specCommand := inspectCommand asSpecCommand.
	self assert: specCommand iconName equals: #glamorousInspect
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testRemoveModelCommandHasTrashIcon [
	| removeCommand specCommand |
	removeCommand := OPRemoveModelCommand new.
	specCommand := removeCommand asSpecCommand.
	self assert: specCommand iconName equals: #glamorousTrash
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testRenameProjectTreeCommandExecuteDelegatesToInheritedWorkbench [

	| workbenchStub contextStub command |
	workbenchStub := Mock new.
	workbenchStub stub renameProject willReturn: nil.
	contextStub := Mock new.
	contextStub stub workbench willReturn: workbenchStub.

	command := OPRenameProjectTreeCommand new.
	command context: contextStub.
	self assert: command workbench identicalTo: workbenchStub.
	command execute.
	workbenchStub should receive renameProject
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testRenameProjectTreeCommandHasEditIcon [
	| renameCommand specCommand |
	renameCommand := OPRenameProjectTreeCommand new.
	specCommand := renameCommand asSpecCommand.
	self assert: specCommand iconName equals: #glamorousEdit
]
