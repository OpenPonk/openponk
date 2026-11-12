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
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPViewModelRegistryTest >> setUp [
	super setUp.
	project := OPProject name: 'Registry Test Project'.
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
	self assertCollection: (registry allChildrenFor: project) includesAll: { container . entityA . entityB . relation }.
	self assert: relationVM modelSource identicalTo: entityA.
	self assert: relationVM modelTarget identicalTo: entityB.
	self assert: entityVM modelSource isNil description: 'Entity without source should answer nil modelSource'.
	self assert: entityVM modelTarget isNil description: 'Entity without target should answer nil modelTarget'.
	announcedChanged := false.
	entityVM announcer when: OPModelChanged do: [ :ann | announcedChanged := true ] for: self.
	entityVM propertyNamed: #name put: 'VIP Customer'.
	self assert: (entityVM propertyNamed: #name) equals: 'VIP Customer'.
	self assert: announcedChanged description: 'Mutating a non-structural property via propertyNamed:put: must announce OPModelChanged'.
	entityVM unsubscribe: self.
	unnamedEntity := OPTestEntityModel new name: '   '; yourself.
	unnamedVM := registry viewModelFor: unnamedEntity.
	self assert: unnamedVM modelDisplayString equals: 'Test Entity Model'.
	self
		assert: (entityVM printString includesSubstring: 'OPTestEntityViewModel')
		description: 'printOn: should include the view model class name'
]
