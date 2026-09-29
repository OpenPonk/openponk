"
I represent a reversible command recording a property modification on a domain model, view model, or controller. I support execution via symbol mutators or Magritte accessors, and time-based coalescing for continuous typing.
"
Class {
	#name : 'OPPropertyChangeCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'viewModel',
		'selector',
		'oldValue',
		'newValue',
		'timestamp',
		'accessor'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'instance creation' }
OPPropertyChangeCommand class >> viewModel: aViewModel selector: aSelector accessor: anAccessor oldValue: anOldValue newValue: aNewValue [

	^ self new
		  viewModel: aViewModel;
		  selector: aSelector;
		  accessor: anAccessor;
		  oldValue: anOldValue;
		  newValue: aNewValue;
		  yourself
]

{ #category : 'instance creation' }
OPPropertyChangeCommand class >> viewModel: aViewModel selector: aSelector oldValue: anOldValue newValue: aNewValue [

	^ self new
		  viewModel: aViewModel;
		  selector: aSelector;
		  oldValue: anOldValue;
		  newValue: aNewValue;
		  yourself
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> accessor [
	^ accessor
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> accessor: anAccessor [
	accessor := anAccessor
]

{ #category : 'executing' }
OPPropertyChangeCommand >> applyValue: aValue [
	"Apply the given value to target using the accessor if available, or polymorphic property gateway."
	viewModel ifNil: [ ^ self ].
	accessor ifNotNil: [
		accessor write: aValue to: viewModel.
		viewModel modelChanged.
		^ self ].
	selector ifNotNil: [
		viewModel propertyNamed: selector put: aValue ]
]

{ #category : 'testing' }
OPPropertyChangeCommand >> canCoalesceWith: aCommand [
	^ aCommand canCoalesceWithPropertyChange: self
]

{ #category : 'testing' }
OPPropertyChangeCommand >> canCoalesceWithPropertyChange: aPreviousCommand [
	viewModel == aPreviousCommand viewModel ifFalse: [ ^ false ].
	accessor ifNotNil: [
		accessor = aPreviousCommand accessor ifFalse: [ ^ false ] ]
	ifNil: [
		self mutatorSelector = aPreviousCommand mutatorSelector ifFalse: [ ^ false ] ].
	^ (timestamp >= aPreviousCommand timestamp)
		and: [ (timestamp - aPreviousCommand timestamp) < self coalescingTimeLimit ]
]

{ #category : 'actions' }
OPPropertyChangeCommand >> coalesceWith: aCommand [
	"Absorb the subsequent property change into the current command."
	newValue := aCommand newValue.
	timestamp := aCommand timestamp
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> coalescingTimeLimit [
	"Time window in which consecutive typing commands are merged."
	^ 1 second
]

{ #category : 'executing' }
OPPropertyChangeCommand >> execute [
	"Apply the new value to the target property."
	self applyValue: newValue.
	timestamp ifNil: [ timestamp := DateAndTime now ]
]

{ #category : 'initialization' }
OPPropertyChangeCommand >> initialize [
	super initialize.
	timestamp := DateAndTime now
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> mutatorSelector [
	"Answer the mutator selector symbol corresponding to the property selector, or nil if selector is unset."
	selector ifNil: [ ^ nil ].
	^ (selector endsWith: ':')
		ifTrue: [ selector asSymbol ]
		ifFalse: [ (selector , ':') asSymbol ]
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> newValue [
	^ newValue
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> newValue: anObject [
	newValue := anObject
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> oldValue [
	^ oldValue
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> oldValue: anObject [
	oldValue := anObject
]

{ #category : 'executing' }
OPPropertyChangeCommand >> redo [
	self applyValue: newValue
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> selector [
	^ selector
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> selector: aSymbol [
	selector := aSymbol
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> timestamp [
	^ timestamp
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> timestamp: aDateAndTime [
	timestamp := aDateAndTime
]

{ #category : 'executing' }
OPPropertyChangeCommand >> undo [
	self applyValue: oldValue
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> viewModel [
	^ viewModel
]

{ #category : 'accessing' }
OPPropertyChangeCommand >> viewModel: aViewModel [

	viewModel := aViewModel
]
