Class {
	#name : 'OPProjectViewReactivityTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench',
		'project',
		'packageModel',
		'diagram'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPProjectViewReactivityTest >> setUp [
	| customPluginRegistry |
	super setUp.
	customPluginRegistry := OPPluginRegistry new.
	customPluginRegistry add: OPTestPlugin new.
	project := OPProject new.
	packageModel := OPTestContainerModel new.
	project addModel: packageModel.
	diagram := (OPOpenPonkDiagram forModelElement: packageModel) name: 'InitialDiagram'.
	project addDiagram: diagram.
	workbench := OPWorkbench new.
	workbench pluginRegistry: customPluginRegistry.
	workbench openProject: project
]

{ #category : 'running' }
OPProjectViewReactivityTest >> tearDown [
	workbench ifNotNil: #close.
	super tearDown
]

{ #category : 'tests' }
OPProjectViewReactivityTest >> testDiagramsListReactsToDiagramAddedAndRemovedWithoutUndoRedoChanged [
	| newDiagram |
	newDiagram := (OPOpenPonkDiagram forModelElement: packageModel) name: 'SecondDiagram'.

	project addDiagram: newDiagram.
	project announcer announce: (OPDiagramAdded diagram: newDiagram).
	self assert: (workbench diagramsList list items includes: newDiagram).

	project removeDiagram: newDiagram.
	project announcer announce: (OPDiagramRemoved diagram: newDiagram).
	self deny: (workbench diagramsList list items includes: newDiagram)
]

{ #category : 'tests' }
OPProjectViewReactivityTest >> testProjectTreeReactsToModelAddedAndRemovedWithoutUndoRedoChanged [
	| secondPackage |
	secondPackage := OPTestContainerModel new.

	project addModel: secondPackage.
	project announcer announce: (OPModelAdded model: secondPackage).
	self assert: (workbench projectTree tree roots first children anySatisfy: [ :eachChildNode261 |
		eachChildNode261 model == secondPackage ]).

	project removeModel: secondPackage.
	project announcer announce: (OPModelRemoved model: secondPackage).
	self deny: (workbench projectTree tree roots first children anySatisfy: [ :eachChildNode261 |
		eachChildNode261 model == secondPackage ])
]
