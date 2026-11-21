"
Abstract base test case for directional relationship ViewModels verifying endpoint attachment, endpoint accessors, endpoint dependencies, and edge creation priority relative to endpoints.
"
Class {
	#name : 'OPAbstractDirectionalRelationshipViewModelTest',
	#superclass : 'OPAbstractViewModelTest',
	#instVars : [
		'sourceModel',
		'targetModel',
		'sourceViewModel',
		'targetViewModel'
	],
	#category : 'OpenPonk-Core-Tests-ViewModels',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'ViewModels'
}

{ #category : 'testing' }
OPAbstractDirectionalRelationshipViewModelTest class >> isAbstract [

	^ self = OPAbstractDirectionalRelationshipViewModelTest
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipViewModelTest >> newSourceModel [

	^ self sourceModelClass new
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipViewModelTest >> newTargetModel [

	^ self targetModelClass new
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipViewModelTest >> registerModelInParent [

	viewModel attachModelFrom: sourceViewModel to: targetViewModel.
	viewModel registerModelIn: parentModel
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipViewModelTest >> registerSourceModel [

	sourceViewModel registerModelIn: self sourceParentModel
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipViewModelTest >> registerTargetModel [

	targetViewModel registerModelIn: self targetParentModel
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipViewModelTest >> setUpAdditionalModels [

	sourceModel := self newSourceModel.
	sourceViewModel := registry viewModelFor: sourceModel.
	self registerSourceModel.
	targetModel := self newTargetModel.
	targetViewModel := registry viewModelFor: targetModel.
	self registerTargetModel
]

{ #category : 'constants' }
OPAbstractDirectionalRelationshipViewModelTest >> sourceModelClass [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipViewModelTest >> sourceParentModel [

	^ rootModel
]

{ #category : 'constants' }
OPAbstractDirectionalRelationshipViewModelTest >> targetModelClass [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipViewModelTest >> targetParentModel [

	^ rootModel
]

{ #category : 'running' }
OPAbstractDirectionalRelationshipViewModelTest >> tearDown [

	targetViewModel := nil.
	sourceViewModel := nil.
	targetModel := nil.
	sourceModel := nil.
	super tearDown
]

{ #category : 'tests' }
OPAbstractDirectionalRelationshipViewModelTest >> testCreateModelIn [

	| createdViewModel createdModel |
	createdViewModel := self viewModelClass new
		                    registry: registry;
		                    yourself.
	createdModel := createdViewModel createModelFrom: sourceViewModel to: targetViewModel in: parentModel.
	self assert: createdModel identicalTo: createdViewModel model.
	self assert: createdModel class equals: self modelClass.
	self assert: createdViewModel modelSource identicalTo: sourceModel.
	self assert: createdViewModel modelTarget identicalTo: targetModel.
	self assertCollection: self allModels includesAll: { createdModel }
]

{ #category : 'tests' }
OPAbstractDirectionalRelationshipViewModelTest >> testCreationPriorityHigherThanEndpoints [

	self
		assert: viewModel creationPriority > sourceViewModel creationPriority
		description: 'Relationship view model creationPriority must be higher than source endpoint priority'.
	self
		assert: viewModel creationPriority > targetViewModel creationPriority
		description: 'Relationship view model creationPriority must be higher than target endpoint priority'
]

{ #category : 'tests' }
OPAbstractDirectionalRelationshipViewModelTest >> testDependingOnElementsIncludesEndpoints [

	self assertCollection: viewModel dependingOnElements includesAll: {
			sourceModel.
			targetModel }
]

{ #category : 'tests' }
OPAbstractDirectionalRelationshipViewModelTest >> testModelEndpoints [

	self assert: viewModel modelSource identicalTo: sourceModel.
	self assert: viewModel modelTarget identicalTo: targetModel
]
