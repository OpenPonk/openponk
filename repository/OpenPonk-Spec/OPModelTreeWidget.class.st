"
I present model entities in a hierarchical tree-like structure.
"
Class {
	#name : #OPModelTreeWidget,
	#superclass : #ComposablePresenter,
	#instVars : [
		'tree',
		'project',
		'adapters',
		'heading',
		'refreshButton'
	],
	#classVars : [
		'Icons'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #'as yet unclassified' }
OPModelTreeWidget class >> contextMenu: aBuilder [
	<opModelNavigatorContextMenu>
	| navigator |
	navigator := aBuilder model.
	(aBuilder item: 'Inspect') action: [ navigator selectedItem inspect ]
]

{ #category : #specs }
OPModelTreeWidget class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :r | 
			r
				add: #heading;
				add: #refreshButton width: 25 ]
			height: self toolbarHeight;
		add: #tree;
		yourself
]

{ #category : #'as yet unclassified' }
OPModelTreeWidget class >> openOn: aProject [
	^ self new
		openOn: aProject;
		openWithSpec
]

{ #category : #specs }
OPModelTreeWidget class >> withoutHeadingSpec [
	^ SpecColumnLayout composed
		add: #tree;
		yourself
]

{ #category : #'menu commands' }
OPModelTreeWidget >> deleteDiagramCommand: aModelElement [
	^ self notYetImplemented
]

{ #category : #'menu commands' }
OPModelTreeWidget >> deleteElementCommand: aModelElement [
	aModelElement owner remove: aModelElement
]

{ #category : #private }
OPModelTreeWidget >> doubleClick [
	| element |
	tree hasSelectedItem
		ifFalse: [ ^ self ].
	element := self selectedItem.
	self flag: 'no registration mechanism for double click available at the moment'.
	OPPluginRegistry default plugins
		detect: [ :each | each modelClass = element class ]
		ifFound: [ self openCommand: element ]
		ifNone: [  ]
]

{ #category : #'menu commands' }
OPModelTreeWidget >> editElementCommand: aModelElement [
	UIManager default inform: 'Editing from tree is disabled'	"disabled due to not having controller at our disposal atm"	"	self openInForm: (self findControllerByModel: aModelElement)"
]

{ #category : #'accessing - spec' }
OPModelTreeWidget >> heading [
	^ heading
]

{ #category : #api }
OPModelTreeWidget >> initialExtent [
	^ 600 @ 800
]

{ #category : #initialization }
OPModelTreeWidget >> initialize [
	super initialize.
	adapters := OPNavigatorAdapters default
]

{ #category : #initialization }
OPModelTreeWidget >> initializeTree [
	tree
		roots: {};
		doubleClick: [ self doubleClick ];
		menu: [ :menu | 
			tree hasSelectedItem
				ifTrue: [ adapters contextMenuFor: self selectedItem in: menu ] ];
		displayBlock: [ :anObject | adapters displayFor: anObject ];
		childrenBlock: [ :anObject | 
			(adapters childrenFor: anObject)
				sorted: [ :a :b | (tree displayBlock value: a) < (tree displayBlock value: b) ] ];
		iconBlock: [ :anObject | adapters iconFor: anObject ].
	tree
		expandRoots;
		autoDeselection: false
]

{ #category : #initialization }
OPModelTreeWidget >> initializeWidgets [
	tree := self newTree.
	self initializeTree.
	self focusOrder add: tree.
	self newWidgetHeading.
	refreshButton := self newButton.
	refreshButton
		icon: (self iconNamed: #glamorousRefresh);
		action: [ self refresh ]
]

{ #category : #'menu commands' }
OPModelTreeWidget >> inspectCommand: anObject [
	anObject inspect
]

{ #category : #initialization }
OPModelTreeWidget >> newWidgetHeading [
	heading := OPWidgetHeading forLabel: self title
]

{ #category : #'menu commands' }
OPModelTreeWidget >> openCommand: aDiagram [
	UIManager default showWaitCursorWhile: [ self workbench openEditorOn: aDiagram ]
]

{ #category : #accessing }
OPModelTreeWidget >> openOn: aProject [
	self workbench announcer
		when: OPEditorFocused
		do: [ :event | 
			project ifNotNil: [ project announcer unsubscribe: self ].
			project := event diagramController model.
			project ifNotNil: [ project when: OPModelChanged do: [ tree updateTree ] ].
			tree
				roots: {project};
				expandRoots ].
	tree expandRoots
]

{ #category : #accessing }
OPModelTreeWidget >> projectController [
	^ self workbench projectController
]

{ #category : #actions }
OPModelTreeWidget >> refresh [
	tree updateTree
]

{ #category : #'accessing - spec' }
OPModelTreeWidget >> refreshButton [
	^ refreshButton
]

{ #category : #'menu commands' }
OPModelTreeWidget >> renameCommand: modelObject [
	OPRenameElementCommand executeOn: modelObject
]

{ #category : #private }
OPModelTreeWidget >> selectedItem [
	^ tree selectedItem content
]

{ #category : #'accessing - spec' }
OPModelTreeWidget >> tree [
	^ tree
]

{ #category : #'accessing - spec' }
OPModelTreeWidget >> workbench [
	^ owner workbench
]
