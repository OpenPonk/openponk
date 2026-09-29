"
I dynamically construct Spec2 property forms for domain models and view models. I bridge form controls to OPUndoManager via OPFormFieldBinding instances, coordinating full transactional support.
"
Class {
	#name : 'OPPropertiesForm',
	#superclass : 'SpPresenter',
	#instVars : [
		'components',
		'whenAccepted',
		'viewModel',
		'undoManager',
		'bindings'
	],
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'layout' }
OPPropertiesForm class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
]

{ #category : 'specs' }
OPPropertiesForm class >> initialWidth [

	^ 260
]

{ #category : 'specs' }
OPPropertiesForm class >> installLink [
	| link |
	self isLinkInstalled
		ifTrue: [ ^ self ].
	link := MetaLink new
		metaObject: [ :args | 
			| desc |
			desc := args first.
			desc label: desc priority asString , ' ' , desc label ];
		selector: #value:;
		arguments: #(arguments);
		control: #before.
	self visitAst link: link
]

{ #category : 'specs' }
OPPropertiesForm class >> isLinkInstalled [

	^ self visitAst links ifNil: [ false ] ifNotNil: [ :links | links isNotEmpty ]
]

{ #category : 'specs' }
OPPropertiesForm class >> minWidth [

	^ 180
]

{ #category : 'specs' }
OPPropertiesForm class >> settingsOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #showPriority)
		parent: #'op-dev';
		target: self;
		label: 'Show Properties Form Priorities';
		description:
			'Show magritte fields priority for the properties form.';
		order: 60
]

{ #category : 'specs' }
OPPropertiesForm class >> showPriority [
	^ self isLinkInstalled
]

{ #category : 'specs' }
OPPropertiesForm class >> showPriority: aBoolean [
	aBoolean
		ifTrue: [ self installLink ]
		ifFalse: [ self uninstallLink ]
]

{ #category : 'specs' }
OPPropertiesForm class >> uninstallLink [
	self visitAst links ifNotNil: [ :links | links asSet do: #uninstall ]
]

{ #category : 'specs' }
OPPropertiesForm class >> visitAst [
	^ (OPPropertiesFormMagritteVisitor >> #visit:) ast
]

{ #category : 'public - adding' }
OPPropertiesForm >> addButton: aName [
	| control |
	control := self newButton.
	control label: aName.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPPropertiesForm >> addCheckbox: aName [
	| control |
	control := self newCheckBox.
	control label: aName.

	self addControl: control.
	^ control
]

{ #category : 'private' }
OPPropertiesForm >> addControl: aControl [

	self addPassiveControl: aControl.
	self focusOrder add: aControl
]

{ #category : 'public - adding' }
OPPropertiesForm >> addDroplist: aName [
	| control |
	self addHeadingLabel: aName.
	
	control := self newDropList.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPPropertiesForm >> addEditableDroplist: aName [

	| control |
	self addHeadingLabel: aName.
	control := self instantiate: OPEditableDropListPresenter.
	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPPropertiesForm >> addEntity: aName [
	| control |
	self addHeadingLabel: aName.
	control := self instantiate: SpSelectEntity.
	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPPropertiesForm >> addHeadingLabel: aLabel [

	^ (self addLabel: aLabel)
		  displayBold: [ true ];
		  yourself
]

{ #category : 'public - adding' }
OPPropertiesForm >> addLabel: aLabel [

	| control |
	control := self newLabel.
	control label: aLabel.

	self addPassiveControl: control.
	^ control
]

{ #category : 'public - adding' }
OPPropertiesForm >> addList: aName [
	| control |
	self addHeadingLabel: aName.
	
	control := self newList.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPPropertiesForm >> addLongText: aName [

	| control |
	self addHeadingLabel: aName.

	control := self instantiate: OPLongTextPresenter.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPPropertiesForm >> addNumberInput: aName [

	| control |
	self addHeadingLabel: aName.

	control := self newNumberInput.

	self addControl: control.
	^ control
]

{ #category : 'private' }
OPPropertiesForm >> addPassiveControl: aControl [

	components add: aControl
]

{ #category : 'public - adding' }
OPPropertiesForm >> addSeparator [
	self addLabel: ''
]

{ #category : 'public - adding' }
OPPropertiesForm >> addText: aName [

	| control |
	self addHeadingLabel: aName.

	control := self newText.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPPropertiesForm >> addTextInput: aName [

	| control |
	self addHeadingLabel: aName.

	control := self newTextInput.

	self addControl: control.
	^ control
]

{ #category : 'binding' }
OPPropertiesForm >> bindCheckbox: aLabel accessor: anAccessor description: aDescription [
	| control binding |
	control := self addCheckbox: aLabel.
	binding := OPFormCheckboxBinding new
		form: self
		presenter: control
		accessor: anAccessor
		description: aDescription.
	self bindings add: binding.
	^ control
]

{ #category : 'binding' }
OPPropertiesForm >> bindCheckbox: aLabel property: aSymbol [
	^ self
		bindCheckbox: aLabel
		accessor: (OPModelPropertyAccessor on: aSymbol)
		description: nil
]

{ #category : 'binding' }
OPPropertiesForm >> bindDroplist: aLabel accessor: anAccessor description: aDescription [
	^ self
		bindDroplist: aLabel
		accessor: anAccessor
		description: aDescription
		configuration: nil
]

{ #category : 'binding' }
OPPropertiesForm >> bindDroplist: aLabel accessor: anAccessor description: aDescription configuration: aConfigBlock [
	| control binding |
	control := self addDroplist: aLabel.
	aConfigBlock ifNotNil: [ aConfigBlock value: control ].
	binding := OPFormDropListBinding new
		form: self
		presenter: control
		accessor: anAccessor
		description: aDescription.
	self bindings add: binding.
	^ control
]

{ #category : 'binding' }
OPPropertiesForm >> bindDroplist: aLabel property: aSymbol items: aCollection [
	^ self
		bindDroplist: aLabel
		accessor: (OPModelPropertyAccessor on: aSymbol)
		description: nil
		configuration: [ :dropListControl |
			dropListControl items: aCollection asOrderedCollection ]
]

{ #category : 'binding' }
OPPropertiesForm >> bindLongText: aLabel accessor: anAccessor description: aDescription [
	| control binding |
	control := self addLongText: aLabel.
	binding := OPFormTextBinding new
		form: self
		presenter: control
		accessor: anAccessor
		description: aDescription.
	self bindings add: binding.
	^ control
]

{ #category : 'binding' }
OPPropertiesForm >> bindLongText: aLabel property: aSymbol [
	^ self
		bindLongText: aLabel
		accessor: (OPModelPropertyAccessor on: aSymbol)
		description: nil
]

{ #category : 'binding' }
OPPropertiesForm >> bindNumberInput: aLabel accessor: anAccessor description: aDescription [
	| control binding |
	control := self addNumberInput: aLabel.
	binding := OPFormNumberBinding new
		form: self
		presenter: control
		accessor: anAccessor
		description: aDescription.
	self bindings add: binding.
	^ control
]

{ #category : 'binding' }
OPPropertiesForm >> bindNumberInput: aLabel property: aSymbol [
	^ self
		bindNumberInput: aLabel
		accessor: (OPModelPropertyAccessor on: aSymbol)
		description: nil
]

{ #category : 'binding' }
OPPropertiesForm >> bindText: aLabel accessor: anAccessor description: aDescription [
	| control binding |
	control := self addText: aLabel.
	binding := OPFormTextBinding new
		form: self
		presenter: control
		accessor: anAccessor
		description: aDescription.
	self bindings add: binding.
	^ control
]

{ #category : 'binding' }
OPPropertiesForm >> bindText: aLabel property: aSymbol [
	^ self
		bindText: aLabel
		accessor: (OPModelPropertyAccessor on: aSymbol)
		description: nil
]

{ #category : 'binding' }
OPPropertiesForm >> bindTextInput: aLabel accessor: anAccessor description: aDescription [

	| control binding |
	control := self addTextInput: aLabel.
	binding := OPFormTextBinding new
		           form: self
		           presenter: control
		           accessor: anAccessor
		           description: aDescription.
	self bindings add: binding.
	^ control
]

{ #category : 'binding' }
OPPropertiesForm >> bindTextInput: aLabel property: aSymbol [
	^ self
		bindTextInput: aLabel
		accessor: (OPModelPropertyAccessor on: aSymbol)
		description: nil
]

{ #category : 'accessing' }
OPPropertiesForm >> bindings [
	^ bindings ifNil: [ bindings := OrderedCollection new ]
]

{ #category : 'accessing' }
OPPropertiesForm >> components [
	^ components ifNil: [ components := OrderedCollection new ]
]

{ #category : 'api - focus' }
OPPropertiesForm >> defaultKeyboardFocus [
	"Answer the first focusable control in the form layout, or self if empty."
	^ self focusOrder ifNotEmpty: #first ifEmpty: [ super defaultKeyboardFocus ]
]

{ #category : 'public' }
OPPropertiesForm >> editController: aController [

	self
		deprecated: 'Use viewModel: instead'
		transformWith: '`@receiver editController: `@arg1' -> '`@receiver viewModel `@arg1 viewModel'.
	self viewModel: aController viewModel
]

{ #category : 'focus' }
OPPropertiesForm >> focusFirstInput [
	"Explicitly request keyboard focus on the first input control and select all its text if applicable."
	self focusOrder ifNotEmpty: [ :controls |
		self takeKeyboardFocus.
		(controls first respondsTo: #selectAll) ifTrue: [
			controls first selectAll ] ]
]

{ #category : 'initialization' }
OPPropertiesForm >> forcedHeights [

	^ { 
		  (SpListPresenter -> 100).
		  (OPLongTextPresenter -> 200).
		  (SpTextPresenter -> 60) } asDictionary
]

{ #category : 'public' }
OPPropertiesForm >> fromMagritteDescriptions: aContainer [
	| visitor |
	visitor := OPPropertiesFormMagritteVisitor new.
	visitor form: self.
	visitor viewModel: self viewModel.
	visitor visit: aContainer
]

{ #category : 'initialization' }
OPPropertiesForm >> initialize [

	self reset.
	super initialize.
	whenAccepted := [ ]
]

{ #category : 'private - building widgets' }
OPPropertiesForm >> initializeLayout [

	| itemsLayout |
	itemsLayout := self class defaultLayout.
	components do: [ :each | 
		itemsLayout add: each withConstraints: [ :constraints | 
			self forcedHeights
				at: each class
				ifPresent: [ :height | constraints height: height ]
				ifAbsent: [ constraints expand: false ] ] ].
	self layout: itemsLayout
]

{ #category : 'initialization' }
OPPropertiesForm >> initializePresenters [

	super initializePresenters.
	self initializeLayout
]

{ #category : 'updating' }
OPPropertiesForm >> rebuildForm [
	| currentViewModel |
	currentViewModel := self viewModel.
	currentViewModel ifNotNil: [ self viewModel: currentViewModel ]
]

{ #category : 'private - building widgets' }
OPPropertiesForm >> rebuildWidget [

	self initializeLayout
]

{ #category : 'private' }
OPPropertiesForm >> removeLast [

	components removeLast.
	self focusOrder removeLast.
]

{ #category : 'private' }
OPPropertiesForm >> removeLast: anAmount [

	anAmount timesRepeat: [ self removeLast ]
]

{ #category : 'private' }
OPPropertiesForm >> reset [
	components := OrderedCollection new.
	bindings := OrderedCollection new.
	self focusOrder: OrderedCollection new
]

{ #category : 'accessing' }
OPPropertiesForm >> undoManager [
	"Answer the undo manager injected into this form."
	^ undoManager
]

{ #category : 'accessing' }
OPPropertiesForm >> undoManager: anUndoManager [
	undoManager ifNotNil: [ :mgr | mgr announcer unsubscribe: self ].
	undoManager := anUndoManager.
	undoManager ifNotNil: [ :mgr |
		mgr announcer weak
			when: OPUndoRedoChanged
			send: #updateBoundValues
			to: self ]
]

{ #category : 'accessing' }
OPPropertiesForm >> updateBoundValues [
	self bindings do: [ :each | each updatePresenterFromModel ]
]

{ #category : 'accessing' }
OPPropertiesForm >> viewModel [
	^ viewModel
]

{ #category : 'public' }
OPPropertiesForm >> viewModel: aViewModel [
	viewModel ifNotNil: [ viewModel formEventsAnnouncer unsubscribe: self ].
	components ifNotEmpty: [ self reset ].
	viewModel := aViewModel.
	viewModel ifNotNil: [
		viewModel buildEditorForm: self.
		viewModel formEventsAnnouncer weak
			when: OPElementFormNeedsRebuild send: #rebuildForm to: self;
			when: OPModelChanged send: #updateBoundValues to: self ].
	self rebuildWidget
]
