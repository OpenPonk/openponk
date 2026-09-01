"
Spec presenter responsible for dynamically generating form controls (such as text inputs, dropdowns, and checkboxes) to edit properties of a selected domain model or view model.
"
Class {
	#name : 'OPDynamicForm',
	#superclass : 'SpPresenter',
	#instVars : [
		'components',
		'whenAccepted',
		'target'
	],
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'layout' }
OPDynamicForm class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
]

{ #category : 'specs' }
OPDynamicForm class >> initialWidth [

	^ 260
]

{ #category : 'specs' }
OPDynamicForm class >> installLink [
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
OPDynamicForm class >> isLinkInstalled [
	^ self visitAst links ifNil: [ false ] ifNotNil: #isNotEmpty
]

{ #category : 'specs' }
OPDynamicForm class >> minWidth [

	^ 180
]

{ #category : 'specs' }
OPDynamicForm class >> settingsOn: aBuilder [

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
OPDynamicForm class >> showPriority [
	^ self isLinkInstalled
]

{ #category : 'specs' }
OPDynamicForm class >> showPriority: aBoolean [
	aBoolean
		ifTrue: [ self installLink ]
		ifFalse: [ self uninstallLink ]
]

{ #category : 'specs' }
OPDynamicForm class >> uninstallLink [
	self visitAst links ifNotNil: [ :links | links asSet do: #uninstall ]
]

{ #category : 'specs' }
OPDynamicForm class >> visitAst [
	^ (OPDynamicFormMagritteVisitor >> #visit:) ast
]

{ #category : 'public - adding' }
OPDynamicForm >> addButton: aName [
	| control |
	control := self newButton.
	control label: aName.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPDynamicForm >> addCheckbox: aName [
	| control |
	control := self newCheckBox.
	control label: aName.

	self addControl: control.
	^ control
]

{ #category : 'private' }
OPDynamicForm >> addControl: aControl [

	components add: aControl.
	self focusOrder add: aControl
]

{ #category : 'public - adding' }
OPDynamicForm >> addDroplist: aName [
	| control |
	self addHeadingLabel: aName.
	
	control := self newDropList.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPDynamicForm >> addEditableDroplist: aName [

	| control |
	self addHeadingLabel: aName.
	control := self instantiate: OPEditableDropListPresenter.
	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPDynamicForm >> addEntity: aName [
	| control |
	self addHeadingLabel: aName.
	control := self instantiate: SpSelectEntity.
	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPDynamicForm >> addHeadingLabel: aLabel [

	^ (self addLabel: aLabel)
		  displayBold: [ true ];
		  yourself
]

{ #category : 'public - adding' }
OPDynamicForm >> addLabel: aLabel [

	| control |
	control := self newLabel.
	control label: aLabel.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPDynamicForm >> addList: aName [
	| control |
	self addHeadingLabel: aName.
	
	control := self newList.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPDynamicForm >> addLongText: aName [

	| control |
	self addHeadingLabel: aName.

	control := self instantiate: OPLongTextPresenter.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPDynamicForm >> addNumberInput: aName [

	| control |
	self addHeadingLabel: aName.

	control := self newNumberInput.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPDynamicForm >> addSeparator [
	self addLabel: ''
]

{ #category : 'public - adding' }
OPDynamicForm >> addText: aName [

	| control |
	self addHeadingLabel: aName.

	control := self newText.

	self addControl: control.
	^ control
]

{ #category : 'public - adding' }
OPDynamicForm >> addTextInput: aName [

	| control |
	self addHeadingLabel: aName.

	control := self newTextInput.

	self addControl: control.
	^ control
]

{ #category : 'public' }
OPDynamicForm >> editController: aController [
	self deprecated: 'Use target: instead' transformWith: '`@receiver editController: `@arg1' -> '`@receiver target: `@arg1'.
	self target: aController
]

{ #category : 'initialization' }
OPDynamicForm >> forcedHeights [

	^ { 
		  (SpListPresenter -> 100).
		  (OPLongTextPresenter -> 200).
		  (SpTextPresenter -> 60) } asDictionary
]

{ #category : 'public' }
OPDynamicForm >> fromMagritteDescriptions: aContainer [
	| visitor |
	visitor := OPDynamicFormMagritteVisitor new.
	visitor form: self.
	visitor controller: target.
	visitor visit: aContainer
]

{ #category : 'initialization' }
OPDynamicForm >> initialize [

	self reset.
	super initialize.
	whenAccepted := [ ]
]

{ #category : 'private - building widgets' }
OPDynamicForm >> initializeLayout [

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
OPDynamicForm >> initializePresenters [

	super initializePresenters.
	self initializeLayout
]

{ #category : 'updating' }
OPDynamicForm >> rebuildForm [
	| currentTarget |
	currentTarget := target.
	currentTarget ifNotNil: [ self target: currentTarget ]
]

{ #category : 'private - building widgets' }
OPDynamicForm >> rebuildWidget [

	self initializeLayout
]

{ #category : 'private' }
OPDynamicForm >> removeLast [

	components removeLast.
	self focusOrder removeLast.
]

{ #category : 'private' }
OPDynamicForm >> removeLast: anAmount [

	anAmount timesRepeat: [ self removeLast ]
]

{ #category : 'private' }
OPDynamicForm >> reset [

	components := OrderedCollection new.
	self focusOrder: OrderedCollection new
]

{ #category : 'accessing' }
OPDynamicForm >> target [
	^ target
]

{ #category : 'public' }
OPDynamicForm >> target: anObjectWithBuildEditorForm [

	target ifNotNil: [ target formEventsAnnouncer unsubscribe: self ].
	components ifNotEmpty: [ self reset ].
	target := anObjectWithBuildEditorForm.
	target ifNotNil: [
			target buildEditorForm: self.
			target formEventsAnnouncer weak
				when: OPElementFormNeedsRebuild
				send: #rebuildForm
				to: self ].
	self
		rebuildWidget;
		takeKeyboardFocus
]
