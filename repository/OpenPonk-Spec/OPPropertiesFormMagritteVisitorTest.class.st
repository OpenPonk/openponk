"
Unit tests verifying the correct translation of Magritte descriptions (like relations, text, and numbers) into corresponding Spec UI widgets by OPDynamicFormMagritteVisitor.
"
Class {
	#name : 'OPPropertiesFormMagritteVisitorTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPPropertiesFormMagritteVisitorTest >> testToManyRelation [
	| visitor form button target relation |
	visitor := OPPropertiesFormMagritteVisitor new.
	form := Mock new.
	button := Mock new.
	target := Mock new.

	(target stub openEditorWithApplication: Any undoManager: Any) willReturn: nil.

	visitor viewModel: target.
	visitor form: form.

	(form stub addButton: (Kind of: String)) willReturn: button.
	form stub application willReturn: nil.
	form stub undoManager willReturn: nil.

	relation := MAToManyRelationDescription new.
	relation accessor:
		(MAPluggableAccessor read: [ :modelElement | #( ) ] write: [ :modelElement :newValue | ]).

	visitor visitToManyRelationDescription: relation.

	(form should receive addButton: (Kind of: String)) once.

	button should receive action: [ :block |
		block value.
		(target should receive openEditorWithApplication: Any undoManager: Any) once ]
]

{ #category : 'tests' }
OPPropertiesFormMagritteVisitorTest >> testVisitStringDescriptionWithEntryCompletion [
	| form desc visitor presenter completion |
	form := OPPropertiesForm new.
	desc := MAStringDescription new.
	desc label: 'Type'.
	desc accessor: (MAPluggableAccessor read: [ :m | 'foo' ] write: [ :m :v | ]).
	completion := EntryCompletion new.
	desc propertyAt: #entryCompletion put: completion.

	visitor := OPPropertiesFormMagritteVisitor new.
	visitor form: form.
	visitor visitStringDescription: desc.

	presenter := form components detect: [ :each | each isKindOf: SpTextInputFieldPresenter ].
	self assert: presenter entryCompletion equals: completion
]

{ #category : 'tests' }
OPPropertiesFormMagritteVisitorTest >> testVisitToManyRelationDescriptionAddsEditButtonToForm [
	"Verifies that visitToManyRelationDescription: adds an Edit button whose action opens the editor on viewModel with form application and undoManager"
	| form undoManager mockViewModel relationDescription editButton visitor |
	form := OPPropertiesForm new.
	undoManager := OPUndoManager new.
	form undoManager: undoManager.

	mockViewModel := Mock new.
	(mockViewModel stub openEditorWithApplication: Any undoManager: Any) willReturn: nil.

	visitor := OPPropertiesFormMagritteVisitor new.
	visitor form: form.
	visitor viewModel: mockViewModel.

	relationDescription := MAToManyRelationDescription new.
	relationDescription label: 'Items'.
	relationDescription accessor: (MAPluggableAccessor
		read: [ :modelElement | #( ) ]
		write: [ :modelElement :newValue | ]).

	visitor visitToManyRelationDescription: relationDescription.

	editButton := form components detect: [ :eachComponent |
		(eachComponent respondsTo: #label) and: [ eachComponent label = 'Edit Items' ] ].

	self assert: editButton isNotNil.

	editButton click.

	(mockViewModel should receive openEditorWithApplication: form application undoManager: undoManager) once
]
