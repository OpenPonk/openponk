"
Abstract base test case for ViewModel unit tests verifying metadata, registry resolution, icons, display strings, deduplicated hierarchy queries, creation, removal, and dynamic property forms.
"
Class {
	#name : 'OPAbstractViewModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'registry',
		'rootModel',
		'parentModel',
		'model',
		'viewModel'
	],
	#category : 'OpenPonk-Core-Tests-ViewModels',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'ViewModels'
}

{ #category : 'testing' }
OPAbstractViewModelTest class >> isAbstract [

	^ self = OPAbstractViewModelTest
]

{ #category : 'accessing' }
OPAbstractViewModelTest >> allModels [

	^ project models flatCollect: [ :eachRoot | { eachRoot } , (registry allChildrenFor: eachRoot) asArray ]
]

{ #category : 'constants' }
OPAbstractViewModelTest >> modelClass [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
OPAbstractViewModelTest >> newModel [

	^ self modelClass new
]

{ #category : 'initialization' }
OPAbstractViewModelTest >> newRootModel [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
OPAbstractViewModelTest >> registerModelInParent [

	model == rootModel ifFalse: [ viewModel registerModelIn: parentModel ]
]

{ #category : 'running' }
OPAbstractViewModelTest >> setUp [

	super setUp.
	project := OPProject named: 'ViewModelTestProject'.
	rootModel := self newRootModel.
	project addModel: rootModel.
	registry := OPViewModelRegistry forProject: project.
	self setUpAdditionalModels.
	parentModel := self setUpParentModel.
	model := self newModel.
	viewModel := registry viewModelFor: model.
	self registerModelInParent
]

{ #category : 'initialization' }
OPAbstractViewModelTest >> setUpAdditionalModels [
	"Hook for subclasses that need additional fixture elements (such as endpoints) before parent setup."

	
]

{ #category : 'initialization' }
OPAbstractViewModelTest >> setUpParentModel [

	^ rootModel
]

{ #category : 'running' }
OPAbstractViewModelTest >> tearDown [

	viewModel := nil.
	model := nil.
	parentModel := nil.
	rootModel := nil.
	registry := nil.
	project := nil.
	super tearDown
]

{ #category : 'tests' }
OPAbstractViewModelTest >> testChildrenModelsHaveNoNilOrDuplicates [

	| children |
	children := viewModel childrenModels.
	self deny: (children anySatisfy: #isNil) description: viewModel className , ' childrenModels must not contain nil'.
	self assert: children asIdentitySet size equals: children size
]

{ #category : 'tests' }
OPAbstractViewModelTest >> testCreateModelIn [

	| createdViewModel createdModel |
	createdViewModel := self viewModelClass new
		                    registry: registry;
		                    yourself.
	createdModel := createdViewModel createModelIn: parentModel.
	self assert: createdModel identicalTo: createdViewModel model.
	self assert: createdModel class equals: self modelClass.
	self assertCollection: self allModels includesAll: { createdModel }
]

{ #category : 'tests' }
OPAbstractViewModelTest >> testCreationPriority [

	self assert: viewModel creationPriority isNumber description: viewModel className , ' creationPriority must return a number'
]

{ #category : 'tests' }
OPAbstractViewModelTest >> testDependentElementsHaveNoNilOrDuplicates [

	| dependents |
	dependents := viewModel dependentElements.
	self deny: (dependents anySatisfy: #isNil) description: viewModel className , ' dependentElements must not contain nil'.
	self assert: dependents asIdentitySet size equals: dependents size
]

{ #category : 'tests' }
OPAbstractViewModelTest >> testDependingOnElementsHasNoNil [

	| depending |
	depending := viewModel dependingOnElements.
	self deny: (depending anySatisfy: #isNil) description: viewModel className , ' dependingOnElements must not contain nil'
]

{ #category : 'tests' }
OPAbstractViewModelTest >> testIcon [

	| icon |
	icon := viewModel icon.
	self deny: icon identicalTo: nil.
	self assert: icon isForm description: viewModel className , ' icon must return a Form'
]

{ #category : 'tests' }
OPAbstractViewModelTest >> testIsNotAbstract [

	self deny: self viewModelClass isAbstract description: self viewModelClass name , ' under test must not be abstract'
]

{ #category : 'tests' }
OPAbstractViewModelTest >> testModelClass [

	self assert: self viewModelClass modelClass equals: self modelClass.
	self assert: viewModel modelClass equals: self modelClass
]

{ #category : 'tests' }
OPAbstractViewModelTest >> testModelDisplayString [

	| displayString |
	displayString := viewModel modelDisplayString.
	self assert: displayString isString description: viewModel className , ' modelDisplayString must return a String'.
	self denyEmpty: displayString
]

{ #category : 'tests' }
OPAbstractViewModelTest >> testRegisteredInViewModelRegistry [

	self assert: (OPViewModelRegistry viewModelClassFor: self modelClass) equals: self viewModelClass.
	self assert: (registry viewModelFor: model) identicalTo: viewModel
]

{ #category : 'tests' }
OPAbstractViewModelTest >> testRemoveModel [

	self assertCollection: self allModels includesAll: { model }.
	viewModel removeModel.
	self denyCollection: self allModels includesAny: { model }
]

{ #category : 'constants' }
OPAbstractViewModelTest >> viewModelClass [

	^ self subclassResponsibility
]
