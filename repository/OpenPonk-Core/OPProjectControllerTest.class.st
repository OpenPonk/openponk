Class {
	#name : 'OPProjectControllerTest',
	#superclass : 'TestCase',
	#instVars : [
		'controller',
		'project'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPProjectControllerTest >> setUp [

	controller := OPProjectController new.
	project := OPProject new.
	controller project: project.
	OPPluginRegistry setDefaultForTesting
]

{ #category : 'running' }
OPProjectControllerTest >> tearDown [
	OPPluginRegistry resetDefault
]

{ #category : 'tests' }
OPProjectControllerTest >> testAddController [

	| dc model |
	dc := OPDiagramController new.
	model := OPTestContainerModel new.
	dc model: model.
	controller addDiagramController: dc.
	self assert: controller controllers asArray equals: { dc }
]

{ #category : 'tests' }
OPProjectControllerTest >> testRemoveController [
	| dc model |
	dc := OPDiagramController new.
	model := OPTestContainerModel new.
	dc model: model.
	controller addDiagramController: dc.
	controller removeDiagramController: dc.
	self deny: (controller hasModel: model).
	self deny: (model announcer hasSubscriber: controller)
]

{ #category : 'tests' }
OPProjectControllerTest >> testSaveProjectEmpty [
	| root store |
	root := FileSystem memory / 'project.opp'.
	controller workbench: OPWorkbench new.
	self deny: root exists.
	controller saveProjectTo: root.
	self assert: root exists.
	store := (FileSystem zip: root) open.
	self assert: (store / 'project' / 'project.json') exists
]

{ #category : 'tests' }
OPProjectControllerTest >> testSaveProjectWithModel [

	| memoryRoot root |
	project addModel: OPTestContainerModel new.
	memoryRoot := FileSystem memory / 'project'.
	controller workbench: OPWorkbench new.
	self deny: memoryRoot exists.
	controller saveProjectTo: memoryRoot.
	root := (FileSystem zip: memoryRoot) open root.
	self assert: (root / 'project' / 'project.json') exists.
	self
		assert: ((root / 'project' / 'models') children collect: #basename)
		equals: { project models first uuid asString }.
	self
		assertCollection:
			(((root / 'project' / 'models') children anyOne / 'model') children 
				 collect: #basename)
		includesAll: (Array with: 'model.ston')
]
