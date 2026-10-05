"
Provides a Spec 2 interface for inspecting and customizing notation element style rules, allowing users to browse metamodel types and stereotypes, modify colors, and reset styles to defaults.
"
Class {
	#name : 'OPNotationStylePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'plugin',
		'treeTable',
		'items',
		'resetButton',
		'changeColorButton'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'instance creation' }
OPNotationStylePresenter class >> forPlugin: aPlugin [
	^ self new
		plugin: aPlugin;
		yourself
]

{ #category : 'opening' }
OPNotationStylePresenter class >> openForPlugin: aPlugin [
	^ (self forPlugin: aPlugin) open
]

{ #category : 'actions' }
OPNotationStylePresenter >> changeColorForType: aTypeName to: aColor [
	OPNotationStyleRegistry default
		atPlugin: plugin
		type: aTypeName
		set: #fillColor
		to: aColor.
	(self itemForType: aTypeName) ifNotNil: [ :item |
		item color: aColor.
		item isOverridden: true ].
	treeTable ifNotNil: [ treeTable roots: self items ]
]

{ #category : 'accessing' }
OPNotationStylePresenter >> colorForType: aTypeName [
	^ (self itemForType: aTypeName) ifNotNil: [ :item | item color ]
]

{ #category : 'private' }
OPNotationStylePresenter >> colorIconFor: aColor [
	| form |
	form := Form extent: 14 @ 14 depth: 32.
	form fillColor: aColor.
	form borderWidth: 1 color: Color gray.
	^ form
]

{ #category : 'layout' }
OPNotationStylePresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: treeTable;
		add: (SpBoxLayout newLeftToRight
			addLast: changeColorButton;
			addLast: resetButton;
			spacing: 5;
			yourself)
		expand: false;
		spacing: 5;
		yourself
]

{ #category : 'initialization' }
OPNotationStylePresenter >> initializePresenters [
	super initializePresenters.
	treeTable := self newTreeTable.
	treeTable
		addColumn: (SpStringTableColumn title: 'Element Type / Stereotype' evaluated: [ :item | item typeName ]);
		addColumn: (SpCompositeTableColumn new
			title: 'Fill Color';
			addColumn: (SpImageTableColumn evaluated: [ :item | self colorIconFor: item color ]) beNotExpandable;
			addColumn: (SpStringTableColumn evaluated: [ :item | '#' , item color asHexString ]);
			yourself);
		addColumn: (SpStringTableColumn title: 'Status' evaluated: [ :item |
			item isOverridden ifTrue: [ 'Custom' ] ifFalse: [ 'Default' ] ]);
		roots: self items;
		children: [ :item | #( ) ].

	changeColorButton := self newButton
		label: 'Change Color...';
		action: [ self promptChangeSelectedColor ];
		yourself.

	resetButton := self newButton
		label: 'Reset to Default';
		action: [ self resetSelectedType ];
		yourself
]

{ #category : 'initialization' }
OPNotationStylePresenter >> initializeWindow: aWindow [
	super initializeWindow: aWindow.
	aWindow
		title: (plugin ifNotNil: [ :p | p name , ' - Notation Style Settings' ] ifNil: [ 'Notation Style Settings' ]);
		initialExtent: 550 @ 450
]

{ #category : 'accessing' }
OPNotationStylePresenter >> itemForType: aTypeName [
	^ self items detect: [ :each | each typeName = aTypeName ] ifNone: [ nil ]
]

{ #category : 'accessing' }
OPNotationStylePresenter >> items [
	^ items ifNil: [ items := OrderedCollection new ]
]

{ #category : 'loading' }
OPNotationStylePresenter >> loadItems [
	| defaultSheet effectiveSheet userRules defaultRules effectiveRules defaultFill effectiveFill isOverridden allTypeNames |
	plugin ifNil: [
		items := OrderedCollection new.
		^ self ].
	defaultSheet := plugin defaultStyleSheet.
	effectiveSheet := plugin styleSheet.
	userRules := OPNotationStyleRegistry default rulesForPlugin: plugin.
	allTypeNames := (defaultSheet rules keys asSet union: userRules keys asSet) asArray sorted.
	items := allTypeNames collect: [ :eachTypeName |
		defaultRules := defaultSheet ruleForType: eachTypeName.
		effectiveRules := effectiveSheet ruleForType: eachTypeName.
		defaultFill := defaultRules at: #fillColor ifAbsent: [ Color white ].
		effectiveFill := effectiveRules at: #fillColor ifAbsent: [ defaultFill ].
		isOverridden := (userRules at: eachTypeName ifAbsent: [ Dictionary new ]) includesKey: #fillColor.
		OPNotationStyleItem new
			typeName: eachTypeName;
			property: #fillColor;
			defaultColor: defaultFill;
			color: effectiveFill;
			isOverridden: isOverridden;
			yourself ].
	treeTable ifNotNil: [ treeTable roots: items ]
]

{ #category : 'accessing' }
OPNotationStylePresenter >> plugin [
	^ plugin
]

{ #category : 'accessing' }
OPNotationStylePresenter >> plugin: aPlugin [
	plugin := aPlugin.
	self loadItems
]

{ #category : 'actions' }
OPNotationStylePresenter >> promptChangeSelectedColor [
	self selectedItem ifNotNil: [ :item |
		| dialog |
		dialog := ColorSelectorDialogWindow new
			title: 'Choose color for ' , item typeName;
			selectedColor: item color.
		dialog openModal.
		dialog cancelled ifFalse: [
			self changeColorForType: item typeName to: dialog selectedColor ] ]
]

{ #category : 'actions' }
OPNotationStylePresenter >> resetAll [
	OPNotationStyleRegistry default resetForPlugin: plugin.
	self loadItems
]

{ #category : 'actions' }
OPNotationStylePresenter >> resetSelectedType [
	self selectedItem ifNotNil: [ :item |
		self resetType: item typeName ]
]

{ #category : 'actions' }
OPNotationStylePresenter >> resetType: aTypeName [
	(self itemForType: aTypeName) ifNotNil: [ :item |
		item color: item defaultColor.
		item isOverridden: false.
		OPNotationStyleRegistry default
			removeAtPlugin: plugin
			type: aTypeName
			property: item property ].
	treeTable ifNotNil: [ treeTable roots: self items ]
]

{ #category : 'accessing' }
OPNotationStylePresenter >> selectedItem [
	^ treeTable selectedItem
]

{ #category : 'accessing' }
OPNotationStylePresenter >> treeTable [
	^ treeTable
]
