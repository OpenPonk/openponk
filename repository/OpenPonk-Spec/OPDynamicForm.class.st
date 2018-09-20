"
!! Responsibility

Creating form controls (text boxes, checkboxes, etc) for editing a controller's model.

!! Collaborators

==DCController>>buildEditorForm:==
"
Class {
	#name : #OPDynamicForm,
	#superclass : #DynamicComposableModel,
	#instVars : [
		'components',
		'heights',
		'whenAccepted',
		'controller',
		'heading'
	],
	#category : 'OpenPonk-Spec-Form'
}

{ #category : #specs }
OPDynamicForm class >> defaultSpec [
	^ SpecLayout composed
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
	self visitAst links ifNotNil: [ :links | links do: #uninstall ]
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
	control := self instantiate: OPEditableDropListModel.
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
	LabelModel -> (lineHeight - 5).
	TextInputFieldModel -> (lineHeight + 2).
	TextModel -> (lineHeight * 4).
	OPEditableDropListModel -> lineHeight.
	DropListModel -> lineHeight.
	CheckBoxModel -> (lineHeight * 1).
	ButtonModel -> (lineHeight * 1.2)} asDictionary
]

{ #category : #'private - building widgets' }
OPDynamicForm >> dynamicLayout [
	| keys height |
	keys := self widgets keys.
	^ SpecLayout composed
		newColumn: [ :c | 
			keys ifNotEmpty: [ 
			c add: #heading height: self class toolbarHeight ].
			keys
				do: [ :key | 
					height := self heightFor: (self perform: key).
					"	((self perform: key) isKindOf: DCSelectEntity)
						ifTrue: [ c newRow: [ :row | row add: key withSpec: #specLayout ] height: height ]"
					"	ifFalse: ["
					height ifNil: [ c add: key ] ifNotNil: [ "]" c add: key height: height ] ].
			c newRow: [ :r | "last row is emtpy to take up all the remaining available space" ] ];
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
	^(self defaultHeights)
"	^ heights" at: aModel class ifAbsent: nil
]

{ #category : #initialization }
OPDynamicForm >> initialize [
	self reset.
	super initialize.
	heading := OPWidgetHeading forLabel: 'Properties'.
	heights := self defaultHeights.
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
