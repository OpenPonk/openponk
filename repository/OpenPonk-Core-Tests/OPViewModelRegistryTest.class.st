Class {
	#name : 'OPViewModelRegistryTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'registry',
		'container',
		'entityA',
		'entityB',
		'relation'
	],
	#category : 'OpenPonk-Core-Tests-ViewModels',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'ViewModels'
}

{ #category : 'running' }
OPViewModelRegistryTest >> setUp [

	super setUp.
	project := OPProject named: 'Registry Test Project'.
	container := OPTestContainerModel new
		             name: 'MainPackage';
		             yourself.
	entityA := OPTestEntityModel new
		           name: 'Customer';
		           yourself.
	entityB := OPTestEntityModel new
		           name: 'Order';
		           yourself.
	relation := OPTestRelationModel new
		            source: entityA;
		            target: entityB;
		            yourself.
	container
		add: entityA;
		add: entityB;
		add: relation.
	project addModel: container.
	registry := OPViewModelRegistry forProject: project
]

{ #category : 'tests' }
OPViewModelRegistryTest >> testDefaultViewModelChildrenModelsIsEmpty [

	| noteViewModel |
	noteViewModel := OPNoteViewModel new.
	self assertEmpty: noteViewModel childrenModels
]

{ #category : 'tests' }
OPViewModelRegistryTest >> testDiagramOnlyNoteAndBoundaryViewModels [
	| diagram note boundary noteVM boundaryVM |
	diagram := OPOpenPonkDiagram forModelElement: container.
	project addDiagram: diagram.
	note := OPNote new
		text: 'Important note';
		owningElement: diagram;
		yourself.
	boundary := OPBoundary new
		name: 'System Boundary';
		owningElement: diagram;
		yourself.
	noteVM := registry viewModelFor: note.
	boundaryVM := registry viewModelFor: boundary.
	self assert: noteVM creationPriority equals: 10.
	self assert: boundaryVM creationPriority equals: 5.
	self assert: noteVM nameOfModel equals: 'Important note'.
	self assert: noteVM descriptionName label equals: 'Text'.
	self assertEmpty: noteVM dependingOnElements.
	self assert: noteVM findParentViewModel identicalTo: (registry viewModelFor: container).
	self assert: boundaryVM findParentViewModel identicalTo: (registry viewModelFor: container).
	self assert: noteVM icon isForm description: 'Diagram-only view model icon should return a Form'
]

{ #category : 'tests' }
OPViewModelRegistryTest >> testIncludesModelFindsUncachedNestedAndSharedModelsAndStopsEarly [

	| secondContainer sharedContainer detachedEntity |
	self assert: (registry includesModel: container) description: 'Root project model must be found in hierarchy'.
	self deny: (registry hasViewModelFor: container) description: 'Matching a direct child must stop without creating its view model'.

	self assert: (registry includesModel: entityA) description: 'Uncached nested model must be found in hierarchy'.
	self
		deny: (registry hasViewModelFor: entityA)
		description: 'Matching a nested direct child must stop without creating its view model'.

	detachedEntity := OPTestEntityModel new
		                  name: 'Detached';
		                  yourself.
	self deny: (registry includesModel: detachedEntity) description: 'Detached model must not be reported as included'.

	container entities remove: entityB.
	self deny: (registry includesModel: entityB) description: 'Removed model must no longer be reported as included'.

	sharedContainer := OPTestContainerModel new
		                   name: 'Shared';
		                   yourself.
	secondContainer := OPTestContainerModel new
		                   name: 'SecondPackage';
		                   yourself.
	container add: sharedContainer.
	secondContainer add: sharedContainer.
	project addModel: secondContainer.
	self
		deny: (registry includesModel: detachedEntity)
		description: 'Traversal over shared containers must terminate without revisiting shared models'
]

{ #category : 'tests' }
OPViewModelRegistryTest >> testModelObjectTypeSubtypeComparisonEdgeCases [

	| subA subB typeWithOne typeWithTwo typeWithB |
	subA := OPModelObjectType named: 'Alpha'.
	subB := OPModelObjectType named: 'Beta'.
	typeWithOne := OPModelObjectType named: 'Class' withSubtype: subA.
	typeWithTwo := OPModelObjectType named: 'Class' withSubtypes: {
			               subA.
			               subB }.
	typeWithB := OPModelObjectType named: 'Class' withSubtype: subB.
	self
		assert: typeWithOne < typeWithTwo
		description: 'Type with fewer matching subtypes should sort before type with additional subtypes'.
	self deny: typeWithTwo < typeWithOne description: 'Type with more subtypes must not sort before its prefix'.
	self assert: typeWithOne < typeWithB description: 'Type with lexicographically smaller subtype should sort first'.
	self deny: typeWithB < typeWithOne description: 'Type with lexicographically larger subtype must not sort first'
]

{ #category : 'tests' }
OPViewModelRegistryTest >> testNewSignalsErrorAndResetCacheRebuildsMapping [
	self
		should: [ OPViewModelRegistry new ]
		raise: Error.
	OPViewModelRegistry resetCache.
	self
		assert: (OPViewModelRegistry viewModelClassFor: OPProject)
		equals: OPProjectViewModel.
	self
		assert: (OPViewModelRegistry viewModelClassFor: OPNote)
		equals: OPNoteViewModel.
	self
		assert: (OPViewModelRegistry viewModelClassFor: OPBoundary)
		equals: OPBoundaryViewModel
]

{ #category : 'tests' }
OPViewModelRegistryTest >> testProductionViewModelsHaveUniqueModelClasses [

	| byModelClass collisions |
	byModelClass := Dictionary new.
	OPViewModel allSubclassesDo: [ :eachClass |
			(eachClass isAbstract not and: [ (eachClass package name endsWith: '-Tests') not ]) ifTrue: [
				(byModelClass at: eachClass modelClass ifAbsentPut: [ OrderedCollection new ]) add: eachClass ] ].
	collisions := byModelClass associations select: [ :eachAssociation | eachAssociation value size > 1 ].
	self assertEmpty: collisions
]

{ #category : 'tests' }
OPViewModelRegistryTest >> testProjectViewModelRegistryInspectionAndCoreExtensions [

	| projectViewModel builder tree plainObject containerDescription contextObject |
	projectViewModel := registry projectViewModel.
	projectViewModel basicRemoveModel.
	self assert: projectViewModel findParentViewModel identicalTo: nil.
	registry removeViewModelFor: Object new.

	builder := SpPresenter newApplication: SpApplication defaultApplication.
	tree := registry inspectTreeIn: builder.
	self assertCollection: tree roots hasSameElements: { projectViewModel }.
	self assert: (tree display value: projectViewModel) equals: projectViewModel modelDisplayString.
	self assert: (tree displayIcon value: projectViewModel) extent equals: projectViewModel icon extent.
	self assertCollection: (tree children value: projectViewModel) hasSameElements: { (registry viewModelFor: container) }.

	plainObject := Object new.
	self assert: plainObject asViewModel identicalTo: plainObject.

	containerDescription := MAContainer new.
	self assert: containerDescription definingContext identicalTo: nil.
	contextObject := Object new.
	containerDescription definingContext: contextObject.
	self assert: containerDescription definingContext identicalTo: contextObject
]

{ #category : 'tests' }
OPViewModelRegistryTest >> testRegistryDelegationQueries [
	| children dependents boundary note projectIcon |
	children := registry childrenFor: container.
	self assert: children size equals: 3.
	dependents := registry dependentFor: entityA.
	self assertCollection: dependents hasSameElements: { relation }.
	self
		assert: (registry displayFor: entityA)
		equals: 'Customer (Test Entity Model)'.
	projectIcon := registry iconFor: project.
	self assert: projectIcon extent equals: OPCoreIcons openponkIcon extent.
	self assert: projectIcon bits equals: OPCoreIcons openponkIcon bits.
	self
		assert: (registry modelTypeFor: entityA) name
		equals: 'Test Entity Model'.
	boundary := OPBoundary new.
	note := OPNote new.
	self
		assert: (registry dependsRoughlyTypeOf: entityA on: note)
		description: 'Entity view model (priority 100) should roughly depend on note view model (priority 10)'.
	self
		assert: (registry dependsRoughlyTypeOf: note on: boundary)
		description: 'Note view model (priority 10) should roughly depend on boundary view model (priority 5)'.
	self
		deny: (registry dependsRoughlyTypeOf: boundary on: note)
		description: 'Boundary view model (priority 5) must not depend on note view model (priority 10)'
]

{ #category : 'tests' }
OPViewModelRegistryTest >> testViewModelEdgeCasesAndFallbackBehavior [

	| plainViewModel relationModel plainRelationViewModel namelessViewModel nilNameModel nilNameViewModel formViewModel rebuildCount changedCount systemViewModel rootClassMock rootViewModelMock prefixModel prefixViewModel opOnlyModel opOnlyViewModel |
	plainViewModel := OPViewModel forModel: (OPTestEntityModel new
			                   name: 'Initial';
			                   yourself).
	changedCount := 0.
	plainViewModel announcer when: OPModelChanged do: [ changedCount := changedCount + 1 ] for: self.
	plainViewModel propertyNamed: nil put: 'Ignored'.
	self assert: plainViewModel model name equals: 'Initial'.
	self assert: changedCount equals: 0.
	plainViewModel propertyNamed: #name: put: 'UpdatedWithColon'.
	self assert: plainViewModel model name equals: 'UpdatedWithColon'.
	self assert: changedCount equals: 1.
	plainViewModel unsubscribe: self.

	formViewModel := OPFormTestViewModel forModel: (OPFormTestModel new
			                  name: 'Alpha';
			                  yourself).
	formViewModel stub structuralPropertySelectors willReturn: #( #name ).
	rebuildCount := 0.
	changedCount := 0.
	formViewModel announcer when: OPElementFormNeedsRebuild do: [ rebuildCount := rebuildCount + 1 ] for: self.
	formViewModel announcer when: OPModelChanged do: [ changedCount := changedCount + 1 ] for: self.
	formViewModel propertyNamed: #name put: 'Beta'.
	self assert: formViewModel model name equals: 'Beta'.
	self assert: rebuildCount equals: 1.
	self assert: changedCount equals: 0.
	formViewModel unsubscribe: self.

	relationModel := OPTestRelationModel new
		                 source: entityA;
		                 target: entityB;
		                 yourself.
	plainRelationViewModel := OPViewModel forModel: relationModel.
	self assert: plainRelationViewModel modelSource identicalTo: entityA.
	self assert: plainRelationViewModel modelTarget identicalTo: entityB.
	plainRelationViewModel attachModelFrom: nil to: nil.
	self assert: (plainRelationViewModel openEditorWithApplication: nil undoManager: nil) identicalTo: plainRelationViewModel.

	plainRelationViewModel restoreEndpointsWithSource: entityB target: entityA.
	self assert: relationModel source identicalTo: entityB.
	self assert: relationModel target identicalTo: entityA.

	namelessViewModel := OPViewModel forModel: Object new.
	self assert: namelessViewModel nameOfModel equals: ''.
	nilNameModel := OPFormTestModel new
		                name: nil;
		                yourself.
	nilNameViewModel := OPViewModel forModel: nilNameModel.
	self assert: nilNameViewModel nameOfModel equals: ''.

	self assertEmpty: formViewModel dependingOnElements.

	systemViewModel := OPFormTestViewModel forModel: OPFormTestModel new.
	systemViewModel stub isSystemElement willReturn: true.
	self deny: systemViewModel isRemovable description: 'System element view model must not be removable'.

	rootClassMock := Mock new.
	rootClassMock stub commonModelClassPrefix willReturn: 'OPTestEntityModel'.
	rootViewModelMock := Mock new.
	rootViewModelMock stub class willReturn: rootClassMock.
	prefixModel := OPTestEntityModel new.
	prefixViewModel := OPFormTestViewModel forModel: prefixModel.
	prefixViewModel stub modelRootViewModel willReturn: rootViewModelMock.
	self assert: prefixViewModel modelType name equals: 'Test Entity Model'.

	opOnlyModel := Mock new.
	opOnlyModel stub className willReturn: 'OP'.
	opOnlyViewModel := OPFormTestViewModel forModel: opOnlyModel.
	self assert: opOnlyViewModel modelType name equals: 'OP'
]

{ #category : 'tests' }
OPViewModelRegistryTest >> testViewModelHierarchyAndPropertiesAndDisplayString [

	| projectVM containerVM entityVM relationVM unnamedEntity unnamedVM announcedChanged |
	projectVM := registry projectViewModel.
	containerVM := registry viewModelFor: container.
	entityVM := registry viewModelFor: entityA.
	relationVM := registry viewModelFor: relation.
	self assert: projectVM asViewModel identicalTo: projectVM.
	self assert: projectVM viewModel identicalTo: projectVM.
	self assert: projectVM project identicalTo: project.
	self assert: projectVM projectViewModel identicalTo: projectVM.
	self assert: projectVM modelRootViewModel identicalTo: projectVM.
	self deny: projectVM isForRootModel description: 'Project view model is not a domain root model'.
	self deny: projectVM isRemovable description: 'Project view model must not be removable'.
	self assert: containerVM isForRootModel description: 'Top-level container model must be recognized as root model'.
	self assert: containerVM isRemovable description: 'Standard container model should be removable'.
	self assert: entityVM modelRootViewModel identicalTo: containerVM.
	self assert: entityVM projectViewModel identicalTo: projectVM.
	self assert: entityVM parentContainerModel identicalTo: container.
	self assertCollection: entityVM dependingOnElements hasSameElements: { container }.
	self assertEmpty: containerVM dependingOnElements.
	self assertCollection: (registry allChildrenFor: project) includesAll: {
			container.
			entityA.
			entityB.
			relation }.
	self assert: relationVM modelSource identicalTo: entityA.
	self assert: relationVM modelTarget identicalTo: entityB.
	self assert: entityVM modelSource identicalTo: nil.
	self assert: entityVM modelTarget identicalTo: nil.
	announcedChanged := false.
	entityVM announcer when: OPModelChanged do: [ :ann | announcedChanged := true ] for: self.
	entityVM propertyNamed: #name put: 'VIP Customer'.
	self assert: (entityVM propertyNamed: #name) equals: 'VIP Customer'.
	self
		assert: announcedChanged
		description: 'Mutating a non-structural property via propertyNamed:put: must announce OPModelChanged'.
	entityVM unsubscribe: self.
	unnamedEntity := OPTestEntityModel new
		                 name: '   ';
		                 yourself.
	unnamedVM := registry viewModelFor: unnamedEntity.
	self assert: unnamedVM modelDisplayString equals: 'Test Entity Model'.
	self
		assert: (entityVM printString includesSubstring: 'OPTestEntityViewModel')
		description: 'printOn: should include the view model class name'
]
