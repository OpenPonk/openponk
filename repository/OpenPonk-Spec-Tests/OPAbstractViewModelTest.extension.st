Extension { #name : 'OPAbstractViewModelTest' }

{ #category : '*OpenPonk-Spec-Tests' }
OPAbstractViewModelTest >> testBuildEditorForm [

	| form |
	form := OPPropertiesForm new.
	[
		self assertEmpty: form layout children.
		form viewModel: viewModel.
		self denyEmpty: form layout children ] ensure: [ form viewModel: nil ]
]
