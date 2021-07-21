"
I show a list of available diagram views for editing.

Right-clicking on a view shows additional options.
"
Class {
	#name : #OPDiagramsWidget,
	#superclass : #ComposablePresenter,
	#instVars : [
		'list',
		'heading',
		'project',
		'adapters',
		'toolbar',
		'editButton',
		'deleteButton',
		'openButton',
		'createButton',
		'cloneButton'
	],
	#classVars : [
		'Icons'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPDiagramsWidget class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #heading height: self toolbarHeight;
		add: #list;
		add: #toolbar height: self toolbarHeight;
		yourself
]

{ #category : #retrieving }
OPDiagramsWidget >> contextMenu: aMenuMorph for: aDiagram [
	aDiagram ifNil: [ ^ aMenuMorph ].
	(aMenuMorph
		add: 'Open diagram'
		target: self
		selector: #openDiagram:
		argument: aDiagram) icon: (self iconNamed: #glamorousOpen).
	(aMenuMorph
		add: 'Copy diagram...'
		target: self
		selector: #copyDiagram:
		argument: aDiagram) icon: (self iconNamed: #smallCopy).
	(aMenuMorph
		add: 'Rename diagram'
		target: self
		selector: #renameDiagram:
		argument: aDiagram) icon: (self iconNamed: #glamorousEdit).
	aMenuMorph addLine.
	(aMenuMorph
		addToggle: 'Delete diagram'
		target: self
		selector: #deleteDiagram:
		getStateSelector: nil
		enablementSelector: [ self isDeleteAllowedFor: aDiagram ]
		argumentList: {aDiagram}) icon: (self iconNamed: #glamorousTrash).
	^ aMenuMorph
]

{ #category : #actions }
OPDiagramsWidget >> copyDiagram: aView [
	| name newView |
	[ name := UIManager default
		request: 'Copy diagram "' , (self displayFor: aView) , '". New name: '
		initialAnswer: aView name
		title: 'Copy' ]
		doWhileTrue: [ name isNotNil and: [ name isEmpty or: [ name = aView name ] ] ].
	name ifNil: [ ^ self ].
	self workbench projectController updateDiagrams.
	newView := project copyDiagram: aView.
	newView name: name.
	self workbench openEditorOnDiagram: newView
]

{ #category : #actions }
OPDiagramsWidget >> createDiagram [
	| name diagram openModel |
	openModel := self workbench focusedEditor
		ifNotNil: [ :editor | editor diagramController model ].
	[ name := UIManager default
		request: 'Diagram name: '
		initialAnswer: openModel name
		title: 'Create new' ]
		doWhileTrue: [ name isNotNil and: [ name isEmpty ] ].
	name ifNil: [ ^ self ].
	diagram := OPDiagram
		emptyOfModel: (openModel ifNil: [ self project models first ]).
	diagram name: name.
	project addDiagram: diagram.
	self workbench openEditorOnDiagram: diagram
]

{ #category : #actions }
OPDiagramsWidget >> deleteDiagram: aView [
	(UIManager default
		confirm: 'Delete view "' , (self displayFor: aView) , '"?'
		label: 'Delete')
		ifFalse: [ ^ self ].
	self workbench deleteDiagram: aView.
	self updateContent
]

{ #category : #accessing }
OPDiagramsWidget >> diagramsIn: aProject [
	^ aProject diagrams
		sorted: #modelType ascending , #modelName ascending
]

{ #category : #retrieving }
OPDiagramsWidget >> displayFor: aDiagramView [
	^ '[' , aDiagramView name , '] ' , (adapters displayFor: aDiagramView model)
]

{ #category : #initialization }
OPDiagramsWidget >> displayRowFor: aView [
	| name nameMorph modelMorph container |
	name := aView name.
	nameMorph := name asTextMorph lock.
	modelMorph := GLMMorphic
		togglingButtonLabelled: aView modelName
		pressed: false
		style: #grayRoundedButton.
	container := OrderedCollection new.
	container
		add: nameMorph;
		add: modelMorph.
	^ Smalltalk ui theme newRowIn: World for: container
]

{ #category : #'accessing - spec' }
OPDiagramsWidget >> heading [
	^ heading
]

{ #category : #initialization }
OPDiagramsWidget >> initialize [
	super initialize.
	adapters := OPNavigatorAdapters default
]

{ #category : #initialization }
OPDiagramsWidget >> initializeList [
	list
		displayBlock: [ :aView | self displayRowFor: aView ];
		icons: [ :aView | adapters iconFor: aView model ];
		doubleClickAction: [ list selectedItem ifNotNil: [ :aView | self openDiagram: aView ] ];
		whenSelectedItemChanged: [ :item | self selectionChanged: item ];
		menu: [ :menu | self contextMenu: menu for: list selectedItem ]
]

{ #category : #initialization }
OPDiagramsWidget >> initializePresenter [
	super initializePresenter.
	self initializeList
]

{ #category : #initialization }
OPDiagramsWidget >> initializeToolbar [
	toolbar
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					openButton := item
						icon: (self iconNamed: #glamorousOpen);
						description: 'Open diagram';
						action: [ self selectedItem ifNotNil: [ :i | self openDiagram: i ] ] ].
			group
				addItem: [ :item | 
					createButton := item
						icon: (self iconNamed: #glamorousAdd);
						description: 'Create empty diagram';
						action: [ self createDiagram ] ].
			group
				addItem: [ :item | 
					cloneButton := item
						icon: (self iconNamed: #smallCopy);
						description: 'Copy diagram';
						action: [ self selectedItem ifNotNil: [ :i | self copyDiagram: i ] ] ].
			group
				addItem: [ :item | 
					editButton := item
						icon: (self iconNamed: #glamorousEdit);
						description: 'Rename diagram';
						action: [ self selectedItem ifNotNil: [ :i | self renameDiagram: i ] ] ].
			group
				addItem: [ :item | 
					deleteButton := item
						icon: (self iconNamed: #glamorousTrash);
						description: 'Delete diagram';
						action: [ self selectedItem ifNotNil: [ :i | self deleteDiagram: i ] ] ] ]
]

{ #category : #initialization }
OPDiagramsWidget >> initializeWidgets [
	(list := self instantiate: FastTableModel) handlesDoubleClick: true.
	list whenBuiltDo: [ :widget | widget widget disableFunction ].
	self newWidgetHeading.
	toolbar := self instantiate: MenuModel.
	self initializeToolbar
]

{ #category : #actions }
OPDiagramsWidget >> isDeleteAllowedFor: aDiagram [
	^ project isNotNil
		and: [ (project diagramsOf: aDiagram model) size > 1 ]
]

{ #category : #'accessing - spec' }
OPDiagramsWidget >> list [
	^ list
]

{ #category : #initialization }
OPDiagramsWidget >> newWidgetHeading [
	heading := OPWidgetHeading forLabel: self title
]

{ #category : #actions }
OPDiagramsWidget >> openDiagram: aView [
	UIManager default showWaitCursorWhile: [ self workbench openEditorOnDiagram: aView ]
]

{ #category : #accessing }
OPDiagramsWidget >> project [
	^ project
]

{ #category : #accessing }
OPDiagramsWidget >> project: aProject [
	project := aProject.
	project whenChanged: [ self updateContent ].
	self updateContent.
	self workbench announcer when: OPEditorUnfocused do: [ :event | list resetSelection ].
	self workbench announcer when: OPEditorFocused do: [ :event | self updateContent ]
]

{ #category : #actions }
OPDiagramsWidget >> renameDiagram: aView [
	| name |
	[ name := UIManager default request: 'Rename view "', (self displayFor: aView), '"' initialAnswer: aView name title: 'Rename' ]
		doWhileTrue: [ name isNotNil and: [ name = aView name ] ].
	name ifNil: [ ^ self ].
	aView name: name
]

{ #category : #actions }
OPDiagramsWidget >> selectedDiagram: aDiagram [
	deleteButton
		enabled: (self isDeleteAllowedFor: aDiagram);
		changed: #enabled.
	editButton
		enabled: true;
		changed: #enabled.
	cloneButton
		enabled: true;
		changed: #enabled
]

{ #category : #accessing }
OPDiagramsWidget >> selectedItem [
	^ list selectedItem
]

{ #category : #actions }
OPDiagramsWidget >> selectionChanged: aDiagram [
	aDiagram ifNil: [ ^ self unselectedDiagram ].
	self selectedDiagram: aDiagram
]

{ #category : #api }
OPDiagramsWidget >> title [
	^ 'Diagrams'
]

{ #category : #'accessing - spec' }
OPDiagramsWidget >> toolbar [
	^ toolbar
]

{ #category : #actions }
OPDiagramsWidget >> unselectedDiagram [
	deleteButton
		enabled: false;
		changed: #enabled.
	editButton
		enabled: false;
		changed: #enabled.
	cloneButton
		enabled: false;
		changed: #enabled
]

{ #category : #actions }
OPDiagramsWidget >> updateContent [
	| diagrams |
	diagrams := self diagramsIn: project.
	list items: diagrams.
	diagrams
		detect: #isSelected
		ifFound: [ :view | list setSelectedItem: view ]
]

{ #category : #'accessing - spec' }
OPDiagramsWidget >> workbench [
	^ owner workbench
]
