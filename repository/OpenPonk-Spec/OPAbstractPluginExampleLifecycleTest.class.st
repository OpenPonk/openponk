Class {
	#name : 'OPAbstractPluginExampleLifecycleTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
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
	self
		assert: templates isNotEmpty
		description: ('Plugin ' , self plugin name , ' must provide at least one example template').
	templates do: [ :eachTemplate |
		self verifyTemplate: eachTemplate ]
]

{ #category : 'verifying' }
OPAbstractPluginExampleLifecycleTest >> verifyTemplate: aProjectTemplate [
	| project controllersCount |
	project := OPProject named: ('LifecycleTest_' , aProjectTemplate name).
	project addModel: aProjectTemplate createModel.
	[
		workbench := OPWorkbench openProject: project.
		workbench showAllElementsInAllDiagrams.
		controllersCount := (workbench projectController controllers flatCollect: [ :diagramController |
			diagramController controllers ]) size.
		self
			assert: controllersCount > 0
			description: ('Template ' , aProjectTemplate name , ' in plugin ' , self plugin name , ' rendered 0 controllers').
		self
			deny: workbench projectController undoManager canUndo
			description: ('Template ' , aProjectTemplate name , ' in plugin ' , self plugin name , ' left dirty undo history')
	] ensure: [
		workbench ifNotNil: [ :activeWorkbench |
			activeWorkbench close.
			workbench := nil ] ]
]
