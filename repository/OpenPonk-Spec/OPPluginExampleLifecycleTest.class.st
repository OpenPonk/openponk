Class {
	#name : 'OPPluginExampleLifecycleTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPPluginExampleLifecycleTest >> setUp [
	super setUp.
	workbench := nil
]

{ #category : 'running' }
OPPluginExampleLifecycleTest >> tearDown [
	workbench ifNotNil: [ :activeWorkbench | 
		activeWorkbench close.
		workbench := nil ].
	super tearDown
]

{ #category : 'tests' }
OPPluginExampleLifecycleTest >> testAllInstalledPluginExampleTemplatesOpenInWorkbenchAndHaveCleanHistory [
	| nonTestingPlugins |
	nonTestingPlugins := OPPluginRegistry default plugins reject: [ :plugin | 
		plugin class isTestingOnly ].
	self assert: nonTestingPlugins isNotEmpty.
	nonTestingPlugins do: [ :plugin | 
		| templates |
		templates := plugin exampleProjectTemplates.
		self assert: templates isNotEmpty description: ('Plugin ' , plugin name , ' must provide at least one example template').
		templates do: [ :template | 
			| project controllersCount |
			project := OPProject named: ('LifecycleTest_' , template name).
			project addModel: template createModel.
			[ 
				workbench := OPWorkbench openProject: project.
				workbench showAllElementsInAllDiagrams.
				controllersCount := (workbench projectController controllers flatCollect: [ :diagramController | 
					diagramController controllers ]) size.
				self assert: controllersCount > 0 description: ('Template ' , template name , ' in plugin ' , plugin name , ' rendered 0 controllers').
				self deny: workbench projectController undoManager canUndo description: ('Template ' , template name , ' in plugin ' , plugin name , ' left dirty undo history')
			] ensure: [ 
				workbench ifNotNil: [ :activeWorkbench | 
					activeWorkbench close.
					workbench := nil ] ] ] ]
]
