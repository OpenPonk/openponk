"
I represent a two-way synchronization bridge between a Spec2 UI widget in OPDynamicForm and a domain property accessed via an accessor. I handle model mutation through reversible OPUndoManager commands and prevent cursor jumping via reentrancy guards.
"
Class {
	#name : 'OPFormFieldBinding',
	#superclass : 'Object',
	#instVars : [
		'form',
		'presenter',
		'accessor',
		'description',
		'isUpdating'
	],
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'accessing' }
OPFormFieldBinding >> accessor [
	^ accessor
]

{ #category : 'updating' }
OPFormFieldBinding >> applyModelValueToPresenter: aValue [
	^ self subclassResponsibility
]

{ #category : 'private' }
OPFormFieldBinding >> commandForOldValue: anOldValue newValue: aNewValue [
	"Answer a domain-specific command if supported by the viewModel, otherwise answer a standard property change command."
	(self viewModel respondsTo: #commandForProperty:accessor:oldValue:newValue:) ifTrue: [
		(self viewModel commandForProperty: self selector accessor: accessor oldValue: anOldValue newValue: aNewValue)
			ifNotNil: [ :cmd | ^ cmd ] ].
	^ OPPropertyChangeCommand
		  viewModel: self viewModel
		  selector: self selector
		  accessor: accessor
		  oldValue: anOldValue
		  newValue: aNewValue
]

{ #category : 'connecting' }
OPFormFieldBinding >> connectPresenter [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPFormFieldBinding >> description [
	^ description
]

{ #category : 'accessing' }
OPFormFieldBinding >> form [
	^ form
]

{ #category : 'accessing' }
OPFormFieldBinding >> form: aForm presenter: aPresenter accessor: anAccessor description: aDescription [
	form := aForm.
	presenter := aPresenter.
	accessor := anAccessor.
	description := aDescription.
	isUpdating := false.
	self updatePresenterFromModel.
	self connectPresenter
]

{ #category : 'accessing' }
OPFormFieldBinding >> presenter [
	^ presenter
]

{ #category : 'updating' }
OPFormFieldBinding >> presenterValueChanged: aNewValue [

	isUpdating ifTrue: [ ^ self ].
	isUpdating := true.
	[
		[
			description ifNotNil: [ :desc | desc validate: aNewValue ].
			self writeModelValue: aNewValue ]
			on: MAValidationError
			do: [ :e |
					OPWorkbench isDevelopmentMode
						ifTrue: [ e pass ]
						ifFalse: [
								(GrowlMorph label: 'Validation Error' contents: e asString)
									backgroundColor: GrowlMorph theme dangerBackgroundColor;
									openInWorld ] ] ] ensure: [ isUpdating := false ]
]

{ #category : 'accessing' }
OPFormFieldBinding >> readModelValue [

	self viewModel ifNil: [ ^ nil ].
	^ accessor read: self viewModel
]

{ #category : 'accessing' }
OPFormFieldBinding >> selector [
	(accessor respondsTo: #selector) ifTrue: [
		accessor selector ifNotNil: [ :s | ^ s asSymbol ] ].
	(accessor respondsTo: #readSelector) ifTrue: [
		accessor readSelector ifNotNil: [ :s | ^ s asSymbol ] ].
	^ nil
]

{ #category : 'accessing' }
OPFormFieldBinding >> undoManager [
	^ form undoManager
]

{ #category : 'updating' }
OPFormFieldBinding >> updatePresenterFromModel [
	| modelValue |
	isUpdating ifTrue: [ ^ self ].
	modelValue := self readModelValue.
	isUpdating := true.
	[ self applyModelValueToPresenter: modelValue ] ensure: [ isUpdating := false ]
]

{ #category : 'accessing' }
OPFormFieldBinding >> viewModel [
	^ form viewModel
]

{ #category : 'private' }
OPFormFieldBinding >> writeModelValue: aNewValue [
	"Write a newly entered value to the model via an undoable command."
	| oldValue command |
	oldValue := self readModelValue.
	oldValue = aNewValue ifTrue: [ ^ self ].
	command := self commandForOldValue: oldValue newValue: aNewValue.
	self undoManager ifNotNil: [ :mgr | mgr execute: command ] ifNil: [ command execute ]
]
