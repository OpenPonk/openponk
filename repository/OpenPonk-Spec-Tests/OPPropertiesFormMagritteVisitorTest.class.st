"
Unit tests verifying the correct translation of Magritte descriptions (like relations, text, and numbers) into corresponding Spec UI widgets by OPDynamicFormMagritteVisitor.
"
Class {
	#name : 'OPPropertiesFormMagritteVisitorTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Form',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Form'
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
OPPropertiesFormMagritteVisitorTest >> testVisitAllMagritteDescriptionTypes [
	| project registry model viewModel form visitor actionExecuted container actionDesc boolDesc readonlyStringDesc shortMemoDesc longMemoDesc singleOptionDesc multiOptionDesc invisibleDesc actionButton |
	project := OPProject new.
	registry := OPViewModelRegistry forProject: project.
	model := OPFormTestModel new.
	viewModel := registry viewModelFor: model.
	form := OPPropertiesForm new.
	form undoManager: OPUndoManager new.
	visitor := OPPropertiesFormMagritteVisitor new.
	visitor form: form.
	visitor target: viewModel.
	self assert: visitor target identicalTo: viewModel.
	self assert: visitor form identicalTo: form.

	actionExecuted := false.
	actionDesc := MAActionDescription new
		label: 'Run Action';
		action: [ actionExecuted := true ];
		priority: 1;
		yourself.
	boolDesc := MABooleanDescription new
		label: 'Active';
		accessor: (MAPluggableAccessor read: [ :vm | true ] write: [ :vm :val | ]);
		priority: 2;
		yourself.
	readonlyStringDesc := MAStringDescription new
		label: 'ReadOnly Label';
		beReadOnly;
		accessor: (MAPluggableAccessor read: [ :vm | 'FixedValue' ] write: [ :vm :val | ]);
		priority: 3;
		yourself.
	shortMemoDesc := MAMemoDescription new
		label: 'Short Memo';
		lineCount: 1;
		accessor: (MAPluggableAccessor read: [ :vm | 'short' ] write: [ :vm :val | ]);
		priority: 4;
		yourself.
	longMemoDesc := MAMemoDescription new
		label: 'Long Memo';
		lineCount: 10;
		accessor: (MAPluggableAccessor read: [ :vm | 'long' ] write: [ :vm :val | ]);
		priority: 5;
		yourself.
	singleOptionDesc := MASingleOptionDescription new
		label: 'Single Option';
		options: #( one two );
		accessor: (MAPluggableAccessor read: [ :vm | #one ] write: [ :vm :val | ]);
		priority: 6;
		yourself.
	multiOptionDesc := MAMultipleOptionDescription new
		label: 'Multi Option';
		options: #( red green blue );
		accessor: (MAPluggableAccessor read: [ :vm | #( red ) ] write: [ :vm :val | ]);
		priority: 7;
		yourself.
	invisibleDesc := MAStringDescription new
		label: 'Hidden';
		visible: false;
		accessor: (MAPluggableAccessor read: [ :vm | 'hidden' ] write: [ :vm :val | ]);
		priority: 8;
		yourself.

	container := MAPriorityContainer new
		label: 'Section';
		priority: 10;
		addAll: {
			boolDesc.
			readonlyStringDesc.
			shortMemoDesc.
			longMemoDesc.
			singleOptionDesc.
			multiOptionDesc.
			invisibleDesc };
		yourself.

	visitor visit: container.
	visitor visitActionDescription: actionDesc.
	self
		deny: (form components anySatisfy: [ :each | (each respondsTo: #text) and: [ each text = 'hidden' ] ])
		description: 'Invisible description must not produce a presenter in the form'.
	self
		assert: (form components anySatisfy: [ :each | each isKindOf: SpCheckBoxPresenter ])
		description: 'Boolean description should create a checkbox presenter'.
	self
		assert: (form components anySatisfy: [ :each | each isKindOf: SpTextPresenter ])
		description: 'Multi-line memo description should create a multi-line text presenter'.
	self
		assert: (form components anySatisfy: [ :each | each isKindOf: SpDropListPresenter ])
		description: 'Single option description should create a drop list presenter'.
	self
		assert: (form components anySatisfy: [ :each | each isKindOf: SpListPresenter ])
		description: 'Multiple option description should create a list presenter'.
	actionButton := form components detect: [ :each |
		(each isKindOf: SpButtonPresenter) and: [ each label = 'Run Action' ] ].
	actionButton click.
	self
		assert: actionExecuted
		description: 'Clicking action description button should execute its action block'
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
	relationDescription display: [ :each | each asString ].
	relationDescription accessor: (MAPluggableAccessor
		read: [ :modelElement | #( 'ItemA' 'ItemB' ) ]
		write: [ :modelElement :newValue | ]).

	visitor visitToManyRelationDescription: relationDescription.

	editButton := form components detect: [ :eachComponent |
		(eachComponent respondsTo: #label) and: [ eachComponent label = 'Edit Items' ] ].

	self
		assert: editButton isNotNil
		description: 'Form should contain the Edit Items button'.

	editButton click.

	(mockViewModel should receive openEditorWithApplication: form application undoManager: undoManager) once
]
