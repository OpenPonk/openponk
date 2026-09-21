"
Unit test verifying that OPPropertyChangeCommand correctly executes and reverts state via an explicit MAAccessor when the selector symbol is absent.
"
Class {
	#name : 'OPPropertyChangeCommandAccessorTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'tests' }
OPPropertyChangeCommandAccessorTest >> testApplyValueViaAccessorWhenSelectorIsNil [

	| target accessor command viewModel |
	target := Dictionary new.
	viewModel := OPPropertiesFormDummyViewModel new.
	viewModel target: target.
	target at: #comment put: 'Initial text'.

	accessor := MAPluggableAccessor read: [ :vm | vm target at: #comment ] write: [ :vm :val | vm target at: #comment put: val ].

	command := OPPropertyChangeCommand
		           viewModel: viewModel
		           selector: nil
		           accessor: accessor
		           oldValue: 'Initial text'
		           newValue: 'Updated text'.

	command execute.
	self assert: (target at: #comment) equals: 'Updated text'.

	command undo.
	self assert: (target at: #comment) equals: 'Initial text'.

	command redo.
	self assert: (target at: #comment) equals: 'Updated text'
]
