"
!! Responsibility

Creating form controls (text boxes, checkboxes, etc) for editing a controller's model.

!! Collaborators

==DCController>>buildEditorForm:==
"
Class {
	#name : #OPDynamicForm,
	#superclass : #DynamicComposablePresenter,
	#instVars : [
		'components',
		'whenAccepted',
		'controller',
		'heading'
	],
	#category : #'OpenPonk-Spec-Form'
}

{ #category : #specs }
OPDynamicForm class >> defaultSpec [
	^ SpecLayout composed
		newColumn: [ :c | c newRow: [ :r |  ] ];
		yourself
]

{ #category : #specs }
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

{ #category : #specs }
OPDynamicForm class >> isLinkInstalled [
	^ self visitAst links ifNil: [ false ] ifNotNil: #isNotEmpty
]

{ #category : #specs }
OPDynamicForm class >> settingsOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #showPriority)
		parent: #openponk;
		target: self;
		label: 'Show Properties Form Priorities';
		description: 'Show magritte fields priority for the properties form.'
]

{ #category : #specs }
OPDynamicForm class >> showPriority [
	^ self isLinkInstalled
]

{ #category : #specs }
OPDynamicForm class >> showPriority: aBoolean [
	aBoolean
		ifTrue: [ self installLink ]
		ifFalse: [ self uninstallLink ]
]

{ #category : #specs }
OPDynamicForm class >> uninstallLink [
	self visitAst links ifNotNil: [ :links | links asSet do: #uninstall ]
]

{ #category : #specs }
OPDynamicForm class >> visitAst [
	^ (OPDynamicFormMagritteVisitor >> #visit:) ast
]

{ #category : #'public - adding' }
OPDynamicForm >> addButton: aName [
	| control |
	control := self newButton.
	control label: aName.

	self addControl: control.
	^ control
]

{ #category : #'public - adding' }
OPDynamicForm >> addCheckbox: aName [
	| control |
	control := self newCheckBox.
	control label: aName.

	self addControl: control.
	^ control
]

{ #category : #private }
OPDynamicForm >> addControl: aControl [
	components add: aControl.
	self focusOrder add: aControl
]

{ #category : #'public - adding' }
OPDynamicForm >> addDroplist: aName [
	| control |
	self addLabel: aName.
	
	control := self newDropList.

	self addControl: control.
	^ control
]

{ #category : #'public - adding' }
OPDynamicForm >> addEditableDroplist: aName [
	| control |
	self addLabel: aName.
	control := self instantiate: OPEditableDropListPresenter.
	self addControl: control.
	^ control
]

{ #category : #'public - adding' }
OPDynamicForm >> addEntity: aName [
	| control |
	self addLabel: aName.
	control := self instantiate: OPSelectEntity.
	self addControl: control.
	^ control
]

{ #category : #'public - adding' }
OPDynamicForm >> addLabel: aLabel [
	| control |
	control := self newLabel.
	control
		label: aLabel;
		emphasis: #(bold).

	self addControl: control.
	^ control
]

{ #category : #'public - adding' }
OPDynamicForm >> addSeparator [
	self addLabel: ''
]

{ #category : #'public - adding' }
OPDynamicForm >> addText: aName [
	| control |
	self addLabel: aName.

	control := self newText.
	control autoAccept: true.

	self addControl: control.
	^ control
]

{ #category : #'public - adding' }
OPDynamicForm >> addTextInput: aName [
	| control |
	self addLabel: aName.

	control := self newTextInput.
	control autoAccept: true.

	self addControl: control.
	^ control
]

{ #category : #'private - building widgets' }
OPDynamicForm >> createWidgets [
	components do: [ :each | self assign: each to: ('control' , each hash asString) asSymbol ]
]

{ #category : #initialization }
OPDynamicForm >> defaultHeights [
	| lineHeight |
	lineHeight := 20.
	^ {OPSelectEntity -> lineHeight.
	LabelPresenter -> (lineHeight - 5).
	TextInputFieldPresenter -> (lineHeight + 2).
	TextPresenter -> (lineHeight * 4).
	OPEditableDropListPresenter -> lineHeight.
	DropListPresenter -> lineHeight.
	CheckBoxPresenter -> (lineHeight * 1).
	ButtonPresenter -> (lineHeight * 1.2)} asDictionary
]

{ #category : #'private - building widgets' }
OPDynamicForm >> dynamicLayout [
	| keys height |
	keys := self widgets keys.
	^ SpecRowLayout composed
		newColumn: [ :c | 
			keys ifNotEmpty: [ c add: #heading height: self class toolbarHeight ].
			keys
				do: [ :key | 
					height := self heightFor: (self perform: key).
					height
						ifNil: [ c add: key ]
						ifNotNil: [ c add: key height: height ] ].
			c newRow: [ :r |  ] ];
		yourself
]

{ #category : #public }
OPDynamicForm >> editController: aController [
	components ifNotEmpty: [ self reset ].
	controller := aController.
	controller ifNotNil: [ controller buildEditorForm: self ].
	self
		rebuildWidget;
		takeKeyboardFocus
]

{ #category : #public }
OPDynamicForm >> fromMagritteDescriptions: aContainer [
	| visitor |
	visitor := OPDynamicFormMagritteVisitor new.
	visitor form: self.
	visitor controller: controller.
	visitor visit: aContainer
]

{ #category : #accessing }
OPDynamicForm >> heading [
	^ heading
]

{ #category : #private }
OPDynamicForm >> heightFor: aModel [
	^ self defaultHeights at: aModel class ifAbsent: nil
]

{ #category : #initialization }
OPDynamicForm >> initialize [
	self reset.
	super initialize.
	heading := OPWidgetHeading forLabel: 'Properties'.
	whenAccepted := [  ]
]

{ #category : #'private - building widgets' }
OPDynamicForm >> rebuildWidget [
	self widgets removeAll.
	self createWidgets.
	self needFullRebuild: false.
	self buildWithSpecLayout: self dynamicLayout.
	self resizeWidgets
]

{ #category : #private }
OPDynamicForm >> reset [
	components := OrderedCollection new.
	focusOrder := OrderedCollection new
]

{ #category : #'private - building widgets' }
OPDynamicForm >> resizeWidgets [
	| font |
	font := LabelMorph labelFont class
		familyName: LabelMorph labelFont familyName
		pointSize: 9.
	self widgets values
		reject: [ :each | each isKindOf: OPSelectEntity ]
		thenDo: [ :each | each widget widget font: font ]
]
