Class {
	#name : 'OPAbstractPluginExampleRoundtripTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench',
		'memoryFile'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
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
	self
		assert: templates isNotEmpty
		description: ('Plugin ' , self plugin name , ' must provide at least one example template').
	templates do: [ :eachTemplate |
		self verifyTemplateRoundtrip: eachTemplate ]
]

{ #category : 'testing' }
OPAbstractPluginExampleRoundtripTest >> verifyTemplateRoundtrip: aProjectTemplate [
	| originalProject originalControllersCount loadedProject loadedControllersCount initialControllersModelUuids loadedControllersModelUuids initialViewModelHierarchyModelUuids loadedViewModelHierarchyModelUuids initialControllerSignatures loadedControllerSignatures initialAllOwnedElementSignatures loadedAllOwnedElementSignatures initialCameras loadedCameras |
	originalProject := OPProject named: ('Roundtrip_' , aProjectTemplate name).
	originalProject addModel: aProjectTemplate createModel.
	[
		workbench := OPWorkbench openProject: originalProject.
		workbench showAllElementsInAllDiagrams.

		originalControllersCount := (workbench projectController controllers flatCollect: [ :eachDiagramControllerA |
			eachDiagramControllerA controllers ]) size.
		self
			assert: originalControllersCount > 0
			description: ('Template ' , aProjectTemplate name , ' in plugin ' , self plugin name , ' rendered 0 controllers').

		initialControllersModelUuids := workbench projectController controllers flatCollect: [ :eachDiagramControllerB |
			eachDiagramControllerB controllers
				select: [ :eachControllerA | eachControllerA model isNotNil ]
				thenCollect: [ :eachControllerA | eachControllerA model uuid asString ] ].

		initialViewModelHierarchyModelUuids := workbench project models flatCollect: [ :eachRootModelA |
			{ eachRootModelA uuid asString } ,
			((workbench projectController viewModelRegistry allChildrenFor: eachRootModelA) collect: [ :eachChildModelA |
				eachChildModelA uuid asString ]) ].

		initialControllerSignatures := workbench projectController controllers flatCollect: [ :eachDiagramControllerC |
			eachDiagramControllerC controllers collect: [ :eachControllerB |
				eachControllerB diagramElement className -> (eachControllerB model ifNotNil: [ :eachModelA | eachModelA uuid asString ]) ] ].

		initialAllOwnedElementSignatures := workbench project diagrams flatCollect: [ :eachDiagramA |
			eachDiagramA allOwnedElements asArray collect: [ :eachDiagramElementA |
				eachDiagramElementA className -> (eachDiagramElementA modelElement ifNotNil: [ :eachModelB | eachModelB uuid asString ]) ] ].

		workbench projectController saveProjectTo: memoryFile.

		initialCameras := workbench project diagrams collect: [ :eachDiagramCameraA |
			eachDiagramCameraA camera ].
		self
			assert: (initialCameras allSatisfy: [ :eachCameraItemA | eachCameraItemA isNotNil ])
			description: ('Diagram camera was nil after saveProjectTo: in template ' , aProjectTemplate name).

		workbench close.
		workbench := nil.

		loadedProject := OPProjectController fromFile: memoryFile.
		self assert: loadedProject isNotNil.
		self assert: loadedProject models size equals: originalProject models size.
		self assert: loadedProject diagrams size equals: originalProject diagrams size.

		workbench := OPWorkbench openProject: loadedProject.
		loadedControllersCount := (workbench projectController controllers flatCollect: [ :eachDiagramControllerD |
			eachDiagramControllerD controllers ]) size.

		loadedControllersModelUuids := workbench projectController controllers flatCollect: [ :eachDiagramControllerE |
			eachDiagramControllerE controllers
				select: [ :eachControllerC | eachControllerC model isNotNil ]
				thenCollect: [ :eachControllerC | eachControllerC model uuid asString ] ].

		loadedViewModelHierarchyModelUuids := workbench project models flatCollect: [ :eachRootModelB |
			{ eachRootModelB uuid asString } ,
			((workbench projectController viewModelRegistry allChildrenFor: eachRootModelB) collect: [ :eachChildModelB |
				eachChildModelB uuid asString ]) ].

		loadedControllerSignatures := workbench projectController controllers flatCollect: [ :eachDiagramControllerF |
			eachDiagramControllerF controllers collect: [ :eachControllerD |
				eachControllerD diagramElement className -> (eachControllerD model ifNotNil: [ :eachModelC | eachModelC uuid asString ]) ] ].

		loadedAllOwnedElementSignatures := workbench project diagrams flatCollect: [ :eachDiagramB |
			eachDiagramB allOwnedElements asArray collect: [ :eachDiagramElementB |
				eachDiagramElementB className -> (eachDiagramElementB modelElement ifNotNil: [ :eachModelD | eachModelD uuid asString ]) ] ].

		loadedCameras := workbench project diagrams collect: [ :eachDiagramCameraB |
			eachDiagramCameraB camera ].

		self assert: loadedControllersCount equals: originalControllersCount.
		self assert: loadedAllOwnedElementSignatures size equals: initialAllOwnedElementSignatures size.
		self assert: loadedControllersModelUuids asBag equals: initialControllersModelUuids asBag.
		self assert: loadedViewModelHierarchyModelUuids asBag equals: initialViewModelHierarchyModelUuids asBag.
		self assert: loadedControllerSignatures asBag equals: initialControllerSignatures asBag.
		self assert: loadedAllOwnedElementSignatures asBag equals: initialAllOwnedElementSignatures asBag.
		self assert: loadedCameras equals: initialCameras.
	] ensure: [
		workbench ifNotNil: [ :activeWorkbench |
			activeWorkbench close.
			workbench := nil ].
		memoryFile ifNotNil: [ :file |
			file ensureDelete ] ]
]
