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
	| editor workbench |
	editor := OPEditor new.
	workbench := OPWorkbench new.
	editor stub workbench willReturn: workbench.
	diagramController editor: editor.
	self assert: diagramController formPresenter isNotNil
]

{ #category : #'tests - connecting' }
OPTestDiagramControllerTest >> testCanBeTargetForEntity [
	self
		assert:
			(diagramController
				canBeTargetFor: (diagramController newControllerFor: OPTestEntityModel new))
]

{ #category : #'tests - rebuilding' }
OPTestDiagramControllerTest >> testCleanView [
	| view |
	view := diagramController view.
	view add: RTBox new element.
	self assert: view elements size > 0.
	diagramController cleanView.
	self assert: view elements asArray equals: #().
	self assert: view edges asArray equals: #()
]

{ #category : #'tests - ui interaction' }
OPTestDiagramControllerTest >> testInitializePalette [
	| palette |
	palette := OPPalette new.
	self assert: palette entries size = 2.
	diagramController initializePalette: palette.
	self assert: palette entries size = 3
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

{ #category : #'tests - rebuilding' }
OPTestDiagramControllerTest >> testRebuildEmpty [
	diagramController rebuild.
	self assert: diagramController controllers asArray equals: {}
]

{ #category : #'tests - rebuilding' }
OPTestDiagramControllerTest >> testRebuildNonEmpty [
	| subModel subController |
	subModel := OPTestEntityModel new.
	diagramController model entities add: subModel.
	diagramController rebuild.
	self assert: diagramController controllers size > 0.
	self
		shouldnt: [ subController := diagramController controllerForModel: subModel ]
		raise: NotFound.
	self assert: (diagramController view elements includes: subController figure)
]

{ #category : #'tests - construction' }
OPTestDiagramControllerTest >> testShowModelInDiagram [
	| entity |
	entity := OPTestEntityModel new.
	diagramController showInDiagramModel: entity
]

{ #category : #'tests - construction' }
OPTestDiagramControllerTest >> testShowModelInDiagramAttachesController [
	| entity |
	entity := OPTestEntityModel new.
	diagramController showInDiagramModel: entity.
	self shouldnt: (diagramController controllerForModel: entity) raise: NotFound
]
