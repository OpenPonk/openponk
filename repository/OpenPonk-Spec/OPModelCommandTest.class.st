"
Verifies the Commander 1 execution contract, context unwrapping, and activation checks for OPModelCommand subclasses.
"
Class {
	#name : 'OPModelCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'testEditor',
		'testCommand',
		'mockWorkbench',
		'projectController'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPModelCommandTest >> setUp [
	super setUp.
	projectController := OPProjectController new.
	projectController project: OPProject new.
	mockWorkbench := Mock new.
	mockWorkbench stub projectController willReturn: projectController.
	mockWorkbench stub workbench willReturn: mockWorkbench.
	mockWorkbench stub announcer willReturn: Announcer new.
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.
	testEditor openEmptyModel: OPTestContainerModel new.
	testCommand := OPModelTestCommand new
]

{ #category : 'running' }
OPModelCommandTest >> tearDown [
	testEditor := nil.
	testCommand := nil.
	mockWorkbench := nil.
	projectController := nil.
	super tearDown
]

{ #category : 'tests' }
OPModelCommandTest >> testCanBeExecutedInContextExtractsEditorUniformly [
	"Verifies that OPModelCommand can extract the editor uniformly from both a tool context and a direct editor."
	| toolContext |
	toolContext := CmdSimpleToolContext for: testEditor.
	self assert: (OPModelCommand editorFromContext: toolContext) equals: testEditor.
	self assert: (OPModelCommand editorFromContext: testEditor) equals: testEditor
]

{ #category : 'tests' }
OPModelCommandTest >> testCommandActivatorExecutesCommandWithToolContext [
	"Verifies that CmdCommandActivator successfully prepares and executes an OPModelCommand in a tool context."
	| toolContext activator |
	toolContext := CmdSimpleToolContext for: testEditor.
	activator := CmdCommandActivator new.
	activator command: testCommand.
	activator context: toolContext.

	activator executeCommand.

	self assert: testCommand isExecuted.
	self assert: testCommand editor equals: testEditor.
	self assert: testCommand diagramController equals: testEditor diagramController
]

{ #category : 'tests' }
OPModelCommandTest >> testDiagramControllerAccessesActiveEditorDiagramController [
	"Verifies that diagramController message reaches the active editor without MessageNotUnderstood."
	| toolContext |
	toolContext := CmdSimpleToolContext for: testEditor.
	testCommand prepareFullExecutionInContext: toolContext.
	self assert: testCommand diagramController equals: testEditor diagramController.
	self assert: testCommand model equals: testEditor diagramController model.
	self assert: testCommand projectController equals: projectController
]

{ #category : 'tests' }
OPModelCommandTest >> testPrepareFullExecutionInContextAcceptsDirectEditor [
	"Verifies backward compatibility when an editor instance is passed directly instead of a tool context."
	testCommand prepareFullExecutionInContext: testEditor.
	self assert: testCommand editor equals: testEditor.
	self assert: testCommand diagramController equals: testEditor diagramController
]

{ #category : 'tests' }
OPModelCommandTest >> testPrepareFullExecutionInContextUnwrapsEditorFromToolContext [
	"Verifies that prepareFullExecutionInContext: unwraps the concrete editor from CmdSimpleToolContext."
	| toolContext |
	toolContext := CmdSimpleToolContext for: testEditor.
	testCommand prepareFullExecutionInContext: toolContext.
	self assert: testCommand editor equals: testEditor
]
