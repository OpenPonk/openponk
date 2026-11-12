"
Unit tests verifying Magritte contract compliance and read/write operations for OPModelPropertyAccessor.
"
Class {
	#name : 'OPModelPropertyAccessorTest',
	#superclass : 'TestCase',
	#instVars : [
		'viewModel',
		'model'
	],
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'running' }
OPModelPropertyAccessorTest >> setUp [

	super setUp.
	model := OPUndoTestViewModel new.
	model name: 'InitialName'.
	viewModel := OPViewModel forModel: model
]

{ #category : 'tests' }
OPModelPropertyAccessorTest >> testCanReadAndWrite [
	| accessor |
	accessor := OPModelPropertyAccessor on: #name.
	self
		assert: (accessor canRead: viewModel)
		description: 'Accessor should be able to read #name from viewModel'.
	self
		assert: (accessor canWrite: viewModel)
		description: 'Accessor should be able to write #name to viewModel'.
	self
		assert: (accessor canRead: model)
		description: 'Accessor should be able to read #name from raw model'.
	self
		assert: (accessor canWrite: model)
		description: 'Accessor should be able to write #name to raw model'.
	self
		deny: (accessor canRead: nil)
		description: 'Accessor must not be able to read from nil'.
	self
		deny: (accessor canWrite: nil)
		description: 'Accessor must not be able to write to nil'
]

{ #category : 'tests' }
OPModelPropertyAccessorTest >> testCustomWriteBlockCompatibility [
	"Verify that pluggable writeBlock customization works seamlessly."

	| accessor customCapturedValue |
	accessor := OPModelPropertyAccessor on: #name.
	customCapturedValue := nil.
	accessor writeBlock: [ :target :value | customCapturedValue := value asUppercase ].
	accessor write: 'custom' to: viewModel.
	self assert: customCapturedValue equals: 'CUSTOM'.
	self assert: accessor selector equals: #name
]

{ #category : 'tests' }
OPModelPropertyAccessorTest >> testDescriptionValidationPasses [
	"Ensure element description validation passes with valid input."
	| accessor description |
	accessor := OPModelPropertyAccessor on: #name.
	description := MAStringDescription new
		accessor: accessor;
		label: 'Name';
		yourself.
	self
		assert: (description validate: 'ValidName')
		identicalTo: description
]

{ #category : 'tests' }
OPModelPropertyAccessorTest >> testInstantiationViaOn [

	| accessor |
	accessor := OPModelPropertyAccessor on: #name.
	self assert: accessor selector equals: #name
]

{ #category : 'tests' }
OPModelPropertyAccessorTest >> testIsConcreteClass [
	"Ensure both class and instance side correctly report non-abstract status."
	self
		deny: OPModelPropertyAccessor isAbstract
		description: 'OPModelPropertyAccessor class must not be abstract'.
	self
		deny: (OPModelPropertyAccessor on: #name) isAbstract
		description: 'OPModelPropertyAccessor instance must not be abstract'
]

{ #category : 'tests' }
OPModelPropertyAccessorTest >> testReadAndWriteFallbackOnRawModel [

	| accessor |
	accessor := OPModelPropertyAccessor on: #name.
	self assert: (accessor read: model) equals: 'InitialName'.
	accessor write: 'RawUpdated' to: model.
	self assert: model name equals: 'RawUpdated'
]

{ #category : 'tests' }
OPModelPropertyAccessorTest >> testReadAndWriteOnViewModelGateway [

	| accessor eventCount |
	accessor := OPModelPropertyAccessor on: #name.
	eventCount := 0.
	viewModel announcer when: OPModelChanged do: [ eventCount := eventCount + 1 ] for: self.
	self assert: (accessor read: viewModel) equals: 'InitialName'.
	accessor write: 'UpdatedName' to: viewModel.
	self assert: model name equals: 'UpdatedName'.
	self assert: (accessor read: viewModel) equals: 'UpdatedName'.
	self assert: eventCount equals: 1
]
