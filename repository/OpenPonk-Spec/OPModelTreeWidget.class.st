"
I present model entities in a hierarchical tree-like structure.
"
Class {
	#name : #OPModelTreeWidget,
	#superclass : #SpPresenter,
	#instVars : [
		'tree',
		'project',
		'adapters',
		'refreshButton'
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

{ #category : #'as yet unclassified' }
OPModelTreeWidget class >> defaultLayout [

	^ SpTabLayout new
		  add: (SpBoxLayout newTopToBottom
				   add: (SpBoxLayout newLeftToRight
						    addLast: #refreshButton
						    withConstraints: [ :constraints | constraints width: 25 ];
						    yourself)
				   height: self toolbarHeight;
				   add: #tree;
				   yourself)
		  label: self title;
		  yourself
]

{ #category : #specs }
OPModelTreeWidget class >> defaultSpec [

	self flag: 'Pharo 9- compatibility'.
	^ self defaultLayout
]

{ #category : #'as yet unclassified' }
OPModelTreeWidget class >> openOn: aProject [
	^ self new
		openOn: aProject;
		openWithSpec
]

{ #category : #specs }
OPModelTreeWidget class >> withoutHeadingSpec [
	^ SpBoxLayout newTopToBottom
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
	element := self selectedItem ifNil: [ ^ self ].
	self flag:
		'no registration mechanism for double click available at the moment'.
	OPPluginRegistry default plugins
		detect: [ :each | each modelClass = element class ]
		ifFound: [ self openCommand: element ]
		ifNone: [  ]
]

{ #category : #'menu commands' }
OPModelTreeWidget >> editElementCommand: aModelElement [
	UIManager default inform: 'Editing from tree is disabled'	"disabled due to not having controller at our disposal atm"	"	self openInForm: (self findControllerByModel: aModelElement)"
]

{ #category : #initialization }
OPModelTreeWidget >> initialize [
	super initialize.
	adapters := OPNavigatorAdapters default
]

{ #category : #'as yet unclassified' }
OPModelTreeWidget >> initializePresenters [
	self initializeTree.
	refreshButton := self newButton.
	refreshButton
		icon: (self iconNamed: #glamorousRefresh);
		action: [ self refresh ]
]

{ #category : #initialization }
OPModelTreeWidget >> initializeTree [

	tree := self newTree.
	tree
		roots: #(  );
		whenActivatedDo: [ self doubleClick ];
		contextMenu: [ 
			self selectedItem ifNotNil: [ :selectedItem | 
					adapters
						contextMenuFor: selectedItem
						projectController: self projectController
						in: self newMenu ] ];
		display: [ :anObject | adapters displayFor: anObject ];
		children: [ :anObject | 
			(adapters childrenFor: anObject) sorted: [ :a :b | 
					(tree display value: a) < (tree display value: b) ] ];
		displayIcon: [ :anObject | adapters iconFor: anObject ];
		expandRoots
]

{ #category : #api }
OPModelTreeWidget >> initializeWindow: aWindow [

	aWindow initialExtent: 600 @ 800
]

{ #category : #'menu commands' }
OPModelTreeWidget >> inspectCommand: anObject [
	anObject inspect
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

	tree refresh
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

	^ tree selectedItem
]

{ #category : #'accessing - spec' }
OPModelTreeWidget >> tree [
	^ tree
]

{ #category : #'accessing - spec' }
OPModelTreeWidget >> workbench [
	^ owner workbench
]
