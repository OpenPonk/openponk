"
Abstract base test suite verifying export, save, and reload cycles for bundled plugin example models.
"
Class {
	#name : 'OPAbstractPluginExampleRoundtripTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench',
		'memoryFile'
	],
	#category : 'OpenPonk-Spec-Tests-Application',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Application'
}

{ #category : 'testing' }
OPAbstractPluginExampleRoundtripTest class >> isAbstract [
	"Answers true if the receiver is the abstract root test case for plugin persistence roundtrips."
	^ self == OPAbstractPluginExampleRoundtripTest
]

{ #category : 'accessing' }
OPAbstractPluginExampleRoundtripTest class >> pluginClass [
	"Answers the concrete OPPlugin class under test."
	^ self subclassResponsibility
]

{ #category : 'testing' }
OPAbstractPluginExampleRoundtripTest class >> shouldInheritSelectors [
	^ true
]

{ #category : 'accessing' }
OPAbstractPluginExampleRoundtripTest >> allOwnedElementSignaturesIn: aProject [

	^ aProject diagrams flatCollect: [ :eachDiagram |
			  eachDiagram allOwnedElements asArray collect: [ :eachDiagramElement |
				  eachDiagramElement className -> (eachDiagramElement modelElement ifNotNil: [ :eachModel | eachModel uuid asString ]) ] ]
]

{ #category : 'accessing' }
OPAbstractPluginExampleRoundtripTest >> controllerModelUuidsIn: aProjectController [

	^ aProjectController controllers flatCollect: [ :eachDiagramController |
			  eachDiagramController controllers
				  select: [ :eachController | eachController model isNotNil ]
				  thenCollect: [ :eachController | eachController model uuid asString ] ]
]

{ #category : 'accessing' }
OPAbstractPluginExampleRoundtripTest >> controllerSignaturesIn: aProjectController [

	^ aProjectController controllers flatCollect: [ :eachDiagramController |
			  eachDiagramController controllers collect: [ :eachController |
				  eachController diagramElement className -> (eachController model ifNotNil: [ :eachModel | eachModel uuid asString ]) ] ]
]

{ #category : 'testing' }
OPAbstractPluginExampleRoundtripTest >> coveredModelClassesInTemplates [
	| coveredClasses workbench |
	coveredClasses := Set new.
	self plugin exampleProjectTemplates do: [ :eachTemplate |
		| project |
		project := OPProject named: ('CoverageCheck_' , eachTemplate name).
		project addModel: eachTemplate createModel.
		[
			workbench := OPWorkbench openProject: project.
			workbench showAllElementsInAllDiagrams.
			workbench projectController controllers do: [ :eachDiagramController |
				eachDiagramController controllers do: [ :eachElementController |
					eachElementController model ifNotNil: [ :activeModel |
						coveredClasses add: activeModel class ] ] ].
		] ensure: [
			workbench ifNotNil: [ :activeWorkbench |
				activeWorkbench close.
				workbench := nil ] ] ].
	^ coveredClasses
]

{ #category : 'accessing' }
OPAbstractPluginExampleRoundtripTest >> defaultTimeLimit [
	"Answers a duration allowing multiple full workbench GUI roundtrips across all example templates in slow CI virtualized environments."
	^ 1 minute
]

{ #category : 'accessing' }
OPAbstractPluginExampleRoundtripTest >> plugin [
	"Answers an instance of the plugin under test."
	^ self pluginClass new
]

{ #category : 'accessing' }
OPAbstractPluginExampleRoundtripTest >> pluginClass [
	"Answers the concrete OPPlugin class under test."
	^ self class pluginClass
]

{ #category : 'running' }
OPAbstractPluginExampleRoundtripTest >> setUp [
	super setUp.
	workbench := nil.
	memoryFile := FileSystem memory root / ('roundtrip_test_' , UUID new asString , '.opp')
]

{ #category : 'accessing' }
OPAbstractPluginExampleRoundtripTest >> supportedModelClasses [
	| diagramController controllerFactory commonModelClasses |
	diagramController := self plugin diagramControllerClass new.
	controllerFactory := diagramController controllerFactory.
	commonModelClasses := (OPDiagramOnlyController allSubclasses collect: [ :eachControllerClass | eachControllerClass modelClass ]) asSet.
	^ (controllerFactory registeredModelClasses reject: [ :eachModelClass |
		commonModelClasses includes: eachModelClass ]) asSet
]

{ #category : 'running' }
OPAbstractPluginExampleRoundtripTest >> tearDown [
	memoryFile ifNotNil: [ :file |
		file ensureDelete.
		memoryFile := nil ].
	workbench ifNotNil: [ :activeWorkbench |
		activeWorkbench close.
		workbench := nil ].
	super tearDown
]

{ #category : 'tests' }
OPAbstractPluginExampleRoundtripTest >> testExampleTemplatesCoverAllSupportedElements [
	| supportedModels coveredModels missingModels |
	supportedModels := self supportedModelClasses.
	coveredModels := self coveredModelClassesInTemplates.
	missingModels := supportedModels copyWithoutAll: coveredModels.

	self
		assert: missingModels isEmpty
		description: [
			'The example templates of plugin ' , self plugin name , ' do not cover all supported elements. Missing: ' ,
			((missingModels collect: [ :eachMissingClass | eachMissingClass name ]) asSortedCollection asArray printString) ]
]

{ #category : 'tests' }
OPAbstractPluginExampleRoundtripTest >> testExampleTemplatesRoundtripPersistence [

	| templates |
	templates := self plugin exampleProjectTemplates.
	self denyEmpty: templates.
	templates do: [ :eachTemplate | self verifyTemplateRoundtrip: eachTemplate ]
]

{ #category : 'asserting' }
OPAbstractPluginExampleRoundtripTest >> verifyDiagramControllerConsistency: aDiagramController [

	self denyEmpty: aDiagramController controllers.
	self assert: aDiagramController isRendered description: 'Diagram controller should be rendered'.
	self assert: aDiagramController diagram isRendered description: 'Diagram element should be rendered'.
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

{ #category : 'asserting' }
OPAbstractPluginExampleRoundtripTest >> verifyTemplateRoundtrip: aProjectTemplate [

	| originalProject loadedProject initialControllersModelUuids loadedControllersModelUuids initialViewModelHierarchyModelUuids loadedViewModelHierarchyModelUuids initialControllerSignatures loadedControllerSignatures initialAllOwnedElementSignatures loadedAllOwnedElementSignatures initialCameras loadedCameras |
	originalProject := OPProject named: 'Roundtrip_' , aProjectTemplate name.
	originalProject addModel: aProjectTemplate createModel.
	workbench := OPWorkbench openProject: originalProject.
	[
		workbench showAllElementsInAllDiagrams.
		self denyEmpty: workbench projectController controllers.
		workbench projectController controllers do: [ :eachDiagramController |
			self verifyDiagramControllerConsistency: eachDiagramController ].

		initialControllersModelUuids := self controllerModelUuidsIn: workbench projectController.
		initialViewModelHierarchyModelUuids := self viewModelHierarchyModelUuidsIn: workbench projectController.
		initialControllerSignatures := self controllerSignaturesIn: workbench projectController.
		initialAllOwnedElementSignatures := self allOwnedElementSignaturesIn: workbench project.

		workbench projectController saveProjectTo: memoryFile.
		initialCameras := workbench project diagrams collect: #camera.
		self denyEmpty: initialCameras.
		initialCameras do: [ :eachCamera | self assert: eachCamera class equals: OPDiagramCamera ].

		workbench close.
		workbench := nil.

		loadedProject := OPProjectController fromFile: memoryFile.
		self assert: loadedProject class equals: OPProject.
		self assert: loadedProject name equals: originalProject name.
		self assert: loadedProject models size equals: originalProject models size.
		self assert: loadedProject diagrams size equals: originalProject diagrams size.

		workbench := OPWorkbench openProject: loadedProject.
		self denyEmpty: workbench projectController controllers.
		workbench projectController controllers do: [ :eachDiagramController |
			self verifyDiagramControllerConsistency: eachDiagramController ].

		loadedControllersModelUuids := self controllerModelUuidsIn: workbench projectController.
		loadedViewModelHierarchyModelUuids := self viewModelHierarchyModelUuidsIn: workbench projectController.
		loadedControllerSignatures := self controllerSignaturesIn: workbench projectController.
		loadedAllOwnedElementSignatures := self allOwnedElementSignaturesIn: workbench project.
		loadedCameras := workbench project diagrams collect: #camera.

		self assertCollection: loadedControllersModelUuids hasSameElements: initialControllersModelUuids.
		self assertCollection: loadedViewModelHierarchyModelUuids hasSameElements: initialViewModelHierarchyModelUuids.
		self assertCollection: loadedControllerSignatures hasSameElements: initialControllerSignatures.
		self assertCollection: loadedAllOwnedElementSignatures hasSameElements: initialAllOwnedElementSignatures.
		self assertCollection: loadedCameras equals: initialCameras ] ensure: [
			workbench ifNotNil: [ :activeWorkbench |
					activeWorkbench close.
					workbench := nil ].
			memoryFile ifNotNil: [ :file | file ensureDelete ] ]
]

{ #category : 'accessing' }
OPAbstractPluginExampleRoundtripTest >> viewModelHierarchyModelUuidsIn: aProjectController [

	^ aProjectController project models flatCollect: [ :eachRootModel |
			  { eachRootModel uuid asString }
			  ,
			  ((aProjectController viewModelRegistry allChildrenFor: eachRootModel) collect: [ :eachChildModel |
				   eachChildModel uuid asString ]) ]
]
