"
I show a list of available diagram views for editing.

Right-clicking on a view shows additional options.
"
Class {
	#name : #OPDiagramViewsWidget,
	#superclass : #ComposableModel,
	#instVars : [
		'list',
		'heading',
		'project',
		'adapters',
		'toolbar',
		'editButton',
		'deleteButton',
		'openButton',
		'cloneButton'
	],
	#classVars : [
		'Icons'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPDiagramViewsWidget class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #heading height: self toolbarHeight;
		add: #list;
		add: #toolbar height: self toolbarHeight;
		yourself
]

{ #category : #actions }
OPDiagramViewsWidget >> cloneView: aView [
	| name newView |
	[ name := UIManager default request: 'View name' initialAnswer: aView model name ]
		doWhileTrue: [ name isNotNil and: [ name = aView name ] ].
	name ifNil: [ ^ self ].
	newView := aView newCopy.
	newView name: name.
	self workbench openEditorOnView: newView
]

{ #category : #retrieving }
OPDiagramViewsWidget >> contextMenu: aMenuMorph for: aView [
	aView ifNil: [ ^ aMenuMorph ].
	(aMenuMorph
		add: 'Open view'
		target: self
		selector: #openView:
		argument: aView) icon: (self iconNamed: #glamorousOpen).
	self flag: #nsmHack.
	aView modelType = #FlowModel
		ifFalse: [ (aMenuMorph
				add: 'Clone view ...'
				target: self
				selector: #cloneView:
				argument: aView) icon: (self iconNamed: #smallRemoteOpen) ].
	aView isDefault
		ifFalse: [ (aMenuMorph
				add: 'Rename view'
				target: self
				selector: #renameView:
				argument: aView) icon: (self iconNamed: #glamorousEdit) ].
	aView isDefault
		ifFalse: [ aMenuMorph addLine.
			(aMenuMorph
				add: 'Delete view'
				target: self
				selector: #deleteView:
				argument: aView) icon: (self iconNamed: #glamorousTrash) ].
	^ aMenuMorph
]

{ #category : #actions }
OPDiagramViewsWidget >> deleteView: aView [
	(UIManager default
		confirm: 'Are you sure you want to remove view ' , (self displayFor: aView) , '?')
		ifFalse: [ ^ self ].
	self workbench closeEditorOfView: aView.
	aView project: nil.
	self updateContent
]

{ #category : #retrieving }
OPDiagramViewsWidget >> displayFor: aDiagramView [
	^ '[' , aDiagramView name , '] ' , (adapters displayFor: aDiagramView model)
]

{ #category : #'accessing - spec' }
OPDiagramViewsWidget >> heading [
	^ heading
]

{ #category : #initialization }
OPDiagramViewsWidget >> initialize [
	super initialize.
	adapters := OPNavigatorAdapters new
]

{ #category : #initialization }
OPDiagramViewsWidget >> initializePresenter [
	super initializePresenter.
	list
		displayBlock: [ :aView | self displayFor: aView ];
		icons: [ :aView | adapters iconFor: aView model ];
		doubleClickAction: [ list selectedItem ifNotNil: [ :aView | self openView: aView ] ];
		whenSelectedItemChanged: [ :item | self selectionChanged: item ];
		menu: [ :menu | self contextMenu: menu for: list selectedItem ]
]

{ #category : #initialization }
OPDiagramViewsWidget >> initializeToolbar [
	toolbar
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					openButton := item
						icon: (self iconNamed: #glamorousOpen);
						description: 'Open view';
						action: [ self selectedItem ifNotNil: [ :i | self openView: i ] ] ].
			group
				addItem: [ :item | 
					cloneButton := item
						icon: (self iconNamed: #smallRemoteOpen);
						description: 'Clone view';
						action: [ self selectedItem ifNotNil: [ :i | self cloneView: i ] ] ].
			group
				addItem: [ :item | 
					editButton := item
						icon: (self iconNamed: #glamorousEdit);
						description: 'Rename view';
						action: [ self selectedItem ifNotNil: [ :i | self renameView: i ] ] ].
			group
				addItem: [ :item | 
					deleteButton := item
						icon: (self iconNamed: #glamorousTrash);
						description: 'Delete view';
						action: [ self selectedItem ifNotNil: [ :i | self deleteView: i ] ] ] ]
]

{ #category : #initialization }
OPDiagramViewsWidget >> initializeWidgets [
	(list := self instantiate: FastTableModel) handlesDoubleClick: true.
	self newWidgetHeading.
	toolbar := self instantiate: MenuModel.
	self initializeToolbar
]

{ #category : #'accessing - spec' }
OPDiagramViewsWidget >> list [
	^ list
]

{ #category : #initialization }
OPDiagramViewsWidget >> newWidgetHeading [
	heading := OPWidgetHeading forLabel: self title
]

{ #category : #actions }
OPDiagramViewsWidget >> openView: aView [
	World showWaitCursorWhile: [ self workbench openEditorOnView: aView ]
]

{ #category : #accessing }
OPDiagramViewsWidget >> project [
	^ project
]

{ #category : #accessing }
OPDiagramViewsWidget >> project: aProject [
	project := aProject.
	project whenChanged: [ self updateContent ].
	self updateContent.
	self workbench announcer when: OPEditorUnfocused do: [ :event | list resetSelection ].
	self workbench announcer when: OPEditorFocused do: [ :event | self updateContent ]
]

{ #category : #actions }
OPDiagramViewsWidget >> renameView: aView [
	| name |
	[ name := UIManager default request: 'View name' initialAnswer: aView name ]
		doWhileTrue: [ name isNotNil and: [ name = aView name ] ].
	name ifNil: [ ^ self ].
	aView name: name
]

{ #category : #accessing }
OPDiagramViewsWidget >> selectedItem [
	^ list selectedItem
]

{ #category : #actions }
OPDiagramViewsWidget >> selectionChanged: aView [
	| enableModification |
	enableModification := aView isNotNil and: [ aView isDefault not ].
	editButton enabled: enableModification.
	deleteButton enabled: enableModification.
	editButton changed: #enabled.
	deleteButton changed: #enabled.
	self flag: #nsmHack.
	(aView isNotNil and: [ aView modelType = #FlowModel ])
		ifTrue: [ cloneButton enabled: false ]
		ifFalse: [ cloneButton enabled: true ].
	cloneButton changed: #enabled
]

{ #category : #api }
OPDiagramViewsWidget >> title [
	^ 'Diagram Views'
]

{ #category : #'accessing - spec' }
OPDiagramViewsWidget >> toolbar [
	^ toolbar
]

{ #category : #actions }
OPDiagramViewsWidget >> updateContent [
	| views |
	views := self viewsIn: project.
	list items: views.
	views detect: #isSelected ifFound: [ :view | list setSelectedItem: view ]
]

{ #category : #accessing }
OPDiagramViewsWidget >> viewsIn: aProject [
	^ aProject views sorted: #modelType ascending , #modelName ascending , #name descending
]

{ #category : #'accessing - spec' }
OPDiagramViewsWidget >> workbench [
	^ owner workbench
]
