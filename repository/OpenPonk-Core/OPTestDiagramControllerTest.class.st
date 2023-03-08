Class {
	#name : #OPTestDiagramControllerTest,
	#superclass : #OPBaseControllerTest,
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #accessing }
OPTestDiagramControllerTest >> controllerClass [
	^ OPTestDiagramController
]

{ #category : #accessing }
OPTestDiagramControllerTest >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : #accessing }
OPTestDiagramControllerTest >> diagramModelClass [
	^ OPTestContainerModel
]

{ #category : #accessing }
OPTestDiagramControllerTest >> modelClass [
	^ OPTestContainerModel
]

{ #category : #'tests - connecting' }
OPTestDiagramControllerTest >> testAddAsTargetForEntity [
	| entityController |
	entityController := diagramController newControllerFor: OPTestEntityModel new.
	diagramController addAsTargetFor: entityController.
	self assert: diagramController model entities asArray equals: {entityController model}.
	self assert: diagramController controllers asArray equals: {entityController}
]

{ #category : #'tests - ui interaction' }
OPTestDiagramControllerTest >> testAttachEditor [
	| editor workbench plugin |
	plugin := OPPlugin new.
	plugin stub layouterClass willReturn: OPLayouter.
	editor := OPEditor on: plugin.
	workbench := OPWorkbench new.
	editor stub workbench willReturn: workbench.
	diagramController editor: editor.
	self assert: diagramController form isNotNil
]

{ #category : #'tests - connecting' }
OPTestDiagramControllerTest >> testCanBeTargetForEntity [
	self
		assert:
			(diagramController
				canBeTargetFor: (diagramController newControllerFor: OPTestEntityModel new))
]

{ #category : #'tests - ui interaction' }
OPTestDiagramControllerTest >> testInitializePalette [
	| palette |
	palette := OPPalette new.
	self assert: palette items size = 2.
	diagramController initializePalette: palette.
	self assert: palette items size = 3
]

{ #category : #tests }
OPTestDiagramControllerTest >> testModelClass [
	| plugin pluginRegistry |
	plugin := OPPlugin new.
	plugin stub modelClass willReturn: self diagramModelClass.
	plugin stub diagramControllerClass willReturn: self diagramControllerClass.
	pluginRegistry := OPPluginRegistry new add: plugin.
	[ OPPluginRegistry setDefault: pluginRegistry.
	self assert: diagramController modelClass equals: self diagramModelClass ]
		ensure: [ OPPluginRegistry setDefault: nil ]
]

{ #category : #'tests - construction' }
OPTestDiagramControllerTest >> testShowModelInDiagram [
	| entity |
	entity := OPTestEntityModel new.
	diagramController showWithoutDependentInDiagramModel: entity
]

{ #category : #'tests - construction' }
OPTestDiagramControllerTest >> testShowModelInDiagramAttachesController [
	| entity |
	entity := OPTestEntityModel new.
	diagramController showWithoutDependentInDiagramModel: entity.
	self shouldnt: (diagramController controllerForModel: entity) raise: NotFound
]
