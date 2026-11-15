"
Abstract base test suite verifying clean initialization, opening, and tear-down of plugin example models.
"
Class {
	#name : 'OPAbstractPluginExampleLifecycleTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench'
	],
	#category : 'OpenPonk-Spec-Tests-Application',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Application'
}

{ #category : 'testing' }
OPAbstractPluginExampleLifecycleTest class >> isAbstract [
	"Answers true if the receiver is the abstract root test case for plugin lifecycles."
	^ self == OPAbstractPluginExampleLifecycleTest
]

{ #category : 'accessing' }
OPAbstractPluginExampleLifecycleTest class >> pluginClass [
	"Answers the concrete OPPlugin class under test."
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPAbstractPluginExampleLifecycleTest >> plugin [
	"Answers an instance of the plugin under test."
	^ self pluginClass new
]

{ #category : 'accessing' }
OPAbstractPluginExampleLifecycleTest >> pluginClass [
	"Answers the concrete OPPlugin class under test."
	^ self class pluginClass
]

{ #category : 'running' }
OPAbstractPluginExampleLifecycleTest >> setUp [
	super setUp.
	workbench := nil
]

{ #category : 'running' }
OPAbstractPluginExampleLifecycleTest >> tearDown [
	workbench ifNotNil: [ :activeWorkbench |
		activeWorkbench close.
		workbench := nil ].
	super tearDown
]

{ #category : 'tests' }
OPAbstractPluginExampleLifecycleTest >> testExampleTemplatesOpenInWorkbenchAndHaveCleanHistory [

	| templates |
	templates := self plugin exampleProjectTemplates.
	self denyEmpty: templates.
	templates do: [ :eachTemplate | self verifyTemplate: eachTemplate ]
]

{ #category : 'verifying' }
OPAbstractPluginExampleLifecycleTest >> verifyDiagramControllerConsistency: aDiagramController [

	self denyEmpty: aDiagramController controllers.
	self assert: aDiagramController isRendered description: 'Diagram controller should be rendered after showing all elements'.
	self assert: aDiagramController diagram isRendered description: 'Diagram element should be rendered after showing all elements'.
	self
		assertCollection: aDiagramController diagram allOwnedElements
		includesAll: (aDiagramController controllers collect: #diagramElement).
	aDiagramController controllers do: [ :eachController |
			self assert: eachController diagramController identicalTo: aDiagramController.
			self assert: eachController isRendered description: 'Element controller should be rendered'.
			self assert: eachController diagramElement isRendered description: 'Element diagramElement should be rendered'.
			self assertCollection: aDiagramController canvas shapes includesAll: { eachController roassalShape }.
			eachController isDiagramOnly ifFalse: [
					self deny: eachController model identicalTo: nil.
					self assert: (aDiagramController controllerForModel: eachController model) identicalTo: eachController ] ]
]

{ #category : 'verifying' }
OPAbstractPluginExampleLifecycleTest >> verifyTemplate: aProjectTemplate [

	| project diagramControllers |
	project := OPProject named: 'LifecycleTest_' , aProjectTemplate name.
	project addModel: aProjectTemplate createModel.
	workbench := OPWorkbench openProject: project.
	[
		workbench showAllElementsInAllDiagrams.
		diagramControllers := workbench projectController controllers.
		self denyEmpty: diagramControllers.
		diagramControllers do: [ :eachDiagramController | self verifyDiagramControllerConsistency: eachDiagramController ].
		self deny: workbench projectController undoManager canUndo description: (String streamContents: [ :stream |
					 stream nextPutAll: 'Template '.
					 stream nextPutAll: aProjectTemplate name.
					 stream nextPutAll: ' in plugin '.
					 stream nextPutAll: self plugin name.
					 stream nextPutAll: ' left dirty undo history' ]) ] ensure: [
			workbench ifNotNil: [ :activeWorkbench |
					activeWorkbench close.
					workbench := nil ] ]
]
