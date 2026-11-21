"
Abstract base test suite verifying ViewModel contracts across all elements of bundled plugin example templates, including registry consistency, deduplicated hierarchy queries, icons, display strings, priority ordering, and dynamic property form construction.
"
Class {
	#name : 'OPAbstractPluginExampleViewModelTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Application',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Application'
}

{ #category : 'testing' }
OPAbstractPluginExampleViewModelTest class >> isAbstract [

	^ self == OPAbstractPluginExampleViewModelTest
]

{ #category : 'accessing' }
OPAbstractPluginExampleViewModelTest class >> pluginClass [

	^ self subclassResponsibility
]

{ #category : 'testing' }
OPAbstractPluginExampleViewModelTest class >> shouldInheritSelectors [

	^ true
]

{ #category : 'accessing' }
OPAbstractPluginExampleViewModelTest >> plugin [

	^ self pluginClass new
]

{ #category : 'accessing' }
OPAbstractPluginExampleViewModelTest >> pluginClass [

	^ self class pluginClass
]

{ #category : 'tests' }
OPAbstractPluginExampleViewModelTest >> testExampleTemplatesViewModelContracts [

	| templates |
	templates := self plugin exampleProjectTemplates.
	self denyEmpty: templates.
	templates do: [ :eachTemplate | self verifyTemplateViewModels: eachTemplate ]
]

{ #category : 'verifying' }
OPAbstractPluginExampleViewModelTest >> verifyEditorFormFor: aViewModel [

	| form |
	form := OPPropertiesForm new.
	[
		form viewModel: aViewModel.
		self denyEmpty: form layout children ] ensure: [ form viewModel: nil ]
]

{ #category : 'verifying' }
OPAbstractPluginExampleViewModelTest >> verifyEndpointPrioritiesFor: aViewModel in: aRegistry [

	| sourceModel targetModel sourceViewModel targetViewModel |
	sourceModel := aViewModel modelSource.
	targetModel := aViewModel modelTarget.
	(sourceModel isNotNil and: [ targetModel isNotNil ]) ifFalse: [ ^ self ].
	sourceViewModel := aRegistry viewModelFor: sourceModel.
	targetViewModel := aRegistry viewModelFor: targetModel.
	self assert: aViewModel creationPriority > sourceViewModel creationPriority description: (String streamContents: [ :stream |
				 stream nextPutAll: aViewModel className.
				 stream nextPutAll: ' creationPriority must be higher than source '.
				 stream nextPutAll: sourceViewModel className ]).
	self assert: aViewModel creationPriority > targetViewModel creationPriority description: (String streamContents: [ :stream |
				 stream nextPutAll: aViewModel className.
				 stream nextPutAll: ' creationPriority must be higher than target '.
				 stream nextPutAll: targetViewModel className ])
]

{ #category : 'verifying' }
OPAbstractPluginExampleViewModelTest >> verifyTemplateViewModels: aProjectTemplate [

	| project rootModel registry rootViewModel allViewModels |
	project := OPProject named: 'ViewModelContract_' , aProjectTemplate name.
	rootModel := aProjectTemplate createModel.
	project addModel: rootModel.
	registry := OPViewModelRegistry forProject: project.
	rootViewModel := registry viewModelFor: rootModel.
	allViewModels := { rootViewModel } , rootViewModel allChildren asArray.
	self denyEmpty: allViewModels.
	allViewModels do: [ :eachViewModel | self verifyViewModel: eachViewModel in: registry ]
]

{ #category : 'verifying' }
OPAbstractPluginExampleViewModelTest >> verifyViewModel: aViewModel in: aRegistry [

	self verifyViewModelIdentity: aViewModel in: aRegistry.
	self verifyViewModelHierarchy: aViewModel.
	self verifyViewModelPresentation: aViewModel.
	self verifyEndpointPrioritiesFor: aViewModel in: aRegistry.
	self verifyEditorFormFor: aViewModel
]

{ #category : 'verifying' }
OPAbstractPluginExampleViewModelTest >> verifyViewModelHierarchy: aViewModel [

	| children dependents depending |
	children := aViewModel childrenModels.
	self deny: (children anySatisfy: #isNil) description: aViewModel className , ' childrenModels must not contain nil'.
	self assert: children asIdentitySet size equals: children size.

	dependents := aViewModel dependentElements.
	self deny: (dependents anySatisfy: #isNil) description: aViewModel className , ' dependentElements must not contain nil'.
	self assert: dependents asIdentitySet size equals: dependents size.

	depending := aViewModel dependingOnElements.
	self deny: (depending anySatisfy: #isNil) description: aViewModel className , ' dependingOnElements must not contain nil'
]

{ #category : 'verifying' }
OPAbstractPluginExampleViewModelTest >> verifyViewModelIdentity: aViewModel in: aRegistry [

	self deny: aViewModel model identicalTo: nil.
	self deny: aViewModel class isAbstract description: aViewModel className , ' must not be abstract'.
	self assert: (aViewModel model isKindOf: aViewModel modelClass) description: (String streamContents: [ :stream |
				 stream nextPutAll: aViewModel className.
				 stream nextPutAll: ' model must be kind of '.
				 stream nextPutAll: aViewModel modelClass name ]).
	self assert: (aRegistry viewModelFor: aViewModel model) identicalTo: aViewModel
]

{ #category : 'verifying' }
OPAbstractPluginExampleViewModelTest >> verifyViewModelPresentation: aViewModel [

	| icon displayString |
	icon := aViewModel icon.
	self deny: icon identicalTo: nil.
	self assert: icon isForm description: aViewModel className , ' icon must return a Form'.

	displayString := aViewModel modelDisplayString.
	self assert: displayString isString description: aViewModel className , ' modelDisplayString must return a String'.
	self denyEmpty: displayString
]
