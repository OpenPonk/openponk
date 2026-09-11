Class {
	#name : 'OPWorkbenchTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPWorkbenchTest >> tearDown [
	workbench ifNotNil: [
		workbench close.
		workbench := nil ].
	super tearDown
]

{ #category : 'tests' }
OPWorkbenchTest >> testPanesRetainWidthOnWorkbenchResize [

	| window initialTreeWidth initialFormWidth |
	workbench := OPWorkbench new.
	window := workbench open.
	window adapter widget extent: 1000 @ 700.
	window adapter widget fullBounds.

	initialTreeWidth := workbench projectTree adapter widget width.
	initialFormWidth := workbench form adapter widget width.

	self assert: initialTreeWidth equals: OPWorkbench initialListsWidth.
	"SpTabLayout applies a 10 px inset (5 px on each side) to its contents"
	self assert: initialFormWidth equals: OPWorkbench initialFormWidth - 10.

	"Resize open window morph horizontally by +400 px"
	window adapter widget extent: 1400 @ 700.
	window adapter widget fullBounds.

	self assert: workbench projectTree adapter widget width equals: initialTreeWidth.

	self assert: workbench form adapter widget width equals: initialFormWidth
]

{ #category : 'tests - shortcuts' }
OPWorkbenchTest >> testSaveProjectDelegatesToProjectController [
	| mockController saveAction |
	workbench := OPWorkbench new.

	"Verify that saving without a controller fails explicitly"
	self should: [ workbench saveProject ] raise: AssertionFailure.

	mockController := OPWorkbenchMockProjectController new.
	workbench instVarNamed: 'projectController' put: mockController.

	saveAction := workbench actions ifNotNil: [ :actions |
		actions allCommands 
			detect: [ :each | each shortcutKey = $s actionModifier ] 
			ifNone: [ nil ] ].

	self assert: saveAction isNotNil description: 'Save shortcut action should be registered on workbench'.
	self assert: saveAction canBeExecuted description: 'Save action should be enabled when projectController is present'.

	saveAction execute.
	self assert: mockController isSaved description: 'Executing save action must delegate to projectController saveProject'
]

{ #category : 'tests - shortcuts' }
OPWorkbenchTest >> testSaveProjectShortcutIsRegistered [
	| saveAction |
	workbench := OPWorkbench new.
	saveAction := workbench actions ifNotNil: [ :actions |
		actions allCommands 
			detect: [ :each | each shortcutKey = $s actionModifier ] 
			ifNone: [ nil ] ].

	self assert: saveAction isNotNil description: 'Save shortcut action should be registered on workbench'.
	self deny: saveAction canBeExecuted description: 'Save action must be disabled when projectController is nil'
]
