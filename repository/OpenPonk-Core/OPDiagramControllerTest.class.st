Class {
	#name : 'OPDiagramControllerTest',
	#superclass : 'OPAbstractDiagramControllerTest',
	#category : 'OpenPonk-Core-Controllers - Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers - Tests'
}

{ #category : 'accessing' }
OPDiagramControllerTest >> controllerClass [
	^ OPTestDiagramController
]

{ #category : 'accessing' }
OPDiagramControllerTest >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : 'accessing' }
OPDiagramControllerTest >> diagramModelClass [
	^ OPTestContainerModel
]

{ #category : 'accessing' }
OPDiagramControllerTest >> modelClass [
	^ OPTestContainerModel
]

{ #category : 'tests - connecting' }
OPDiagramControllerTest >> testAddAsTargetForEntity [
	| entityController |
	entityController := diagramController newControllerFor: OPTestEntityModel new.
	diagramController addAsTargetFor: entityController.
	self assert: diagramController model entities asArray equals: {entityController model}.
	self assert: diagramController controllers asArray equals: {entityController}
]

{ #category : 'tests - ui interaction' }
OPDiagramControllerTest >> testAttachEditor [
	| editor workbench plugin |
	plugin := OPPlugin new.
	plugin stub layouterClass willReturn: OPLayouter.
	editor := OPEditor on: plugin.
	workbench := OPWorkbench new.
	editor stub workbench willReturn: workbench.
	diagramController editor: editor.
	self assert: diagramController form isNotNil
]

{ #category : 'tests - connecting' }
OPDiagramControllerTest >> testCanBeTargetForEntity [
	self
		assert:
			(diagramController
				canBeTargetFor: (diagramController newControllerFor: OPTestEntityModel new))
]

{ #category : 'tests - ui interaction' }
OPDiagramControllerTest >> testInitializePalette [
	| palette |
	palette := OPPalette new.
	self assert: palette items size = 2.
	diagramController initializePalette: palette.
	self assert: palette items size = 3
]

{ #category : 'tests' }
OPDiagramControllerTest >> testModelClass [
	| plugin pluginRegistry |
	plugin := OPPlugin new.
	plugin stub modelClass willReturn: self diagramModelClass.
	plugin stub diagramControllerClass willReturn: self diagramControllerClass.
	pluginRegistry := OPPluginRegistry new add: plugin.
	[ OPPluginRegistry setDefault: pluginRegistry.
	self assert: diagramController modelClass equals: self diagramModelClass ]
		ensure: [ OPPluginRegistry setDefault: nil ]
]

{ #category : 'tests - construction' }
OPDiagramControllerTest >> testShowModelInDiagram [
	| entity |
	entity := OPTestEntityModel new.
	diagramController showWithoutDependentInDiagramModel: entity
]

{ #category : 'tests - construction' }
OPDiagramControllerTest >> testShowModelInDiagramAttachesController [
	| entity |
	entity := OPTestEntityModel new.
	diagramController showWithoutDependentInDiagramModel: entity.
	self shouldnt: (diagramController controllerForModel: entity) raise: NotFound
]
