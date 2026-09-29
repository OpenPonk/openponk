"
Unit tests verifying that OPViewModel property gateway mutates the domain model and dispatches change announcements.
"
Class {
	#name : 'OPViewModelPropertyGatewayTest',
	#superclass : 'TestCase',
	#instVars : [
		'viewModel',
		'model',
		'eventCount'
	],
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'running' }
OPViewModelPropertyGatewayTest >> setUp [

	super setUp.
	model := OPUndoTestViewModel new.
	model name: 'Original'.
	viewModel := OPViewModel forModel: model.
	eventCount := 0.
	viewModel announcer when: OPModelChanged do: [ eventCount := eventCount + 1 ] for: self
]

{ #category : 'tests' }
OPViewModelPropertyGatewayTest >> testModelPropertyAccessor [

	| accessor |
	accessor := OPModelPropertyAccessor on: #name.
	self assert: (accessor read: viewModel) equals: 'Original'.
	accessor write: 'ViaAccessor' to: viewModel.
	self assert: model name equals: 'ViaAccessor'.
	self assert: eventCount equals: 1
]

{ #category : 'tests' }
OPViewModelPropertyGatewayTest >> testReadAndWritePropertyThroughGateway [
	self assert: (viewModel propertyNamed: #name) equals: 'Original'.
	viewModel propertyNamed: #name put: 'Updated'.
	self assert: model name equals: 'Updated'.
	self assert: (viewModel propertyNamed: #name) equals: 'Updated'.
	self assert: eventCount equals: 1
]
