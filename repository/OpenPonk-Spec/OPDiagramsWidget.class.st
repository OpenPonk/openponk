"
I show a list of available diagram views for editing.

Right-clicking on a view shows additional options.
"
Class {
	#name : #OPDiagramsWidget,
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
OPDiagramsWidget class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #heading height: self toolbarHeight;
		add: #list;
		add: #toolbar height: self toolbarHeight;
		yourself
]

{ #category : #actions }
OPDiagramsWidget >> cloneView: aView [
	| name newView |
	[ name := UIManager default
		request: 'Clone view "' , (self displayFor: aView) , '". New name: '
		initialAnswer: aView name
		title: 'Clone' ] doWhileTrue: [ name isNotNil and: [ name = aView name ] ].
	name ifNil: [ ^ self ].
	newView := aView newCopy.
	newView name: name.
	self workbench openEditorOnDiagram: newView
]

{ #category : #retrieving }
OPDiagramsWidget >> contextMenu: aMenuMorph for: aView [
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
OPDiagramsWidget >> deleteView: aView [
	(UIManager default
		confirm: 'Delete view "' , (self displayFor: aView) , '"?'
		label: 'Delete')
		ifFalse: [ ^ self ].
	self workbench closeEditorOfView: aView.
	aView project: nil.
	self updateContent
]

{ #category : #retrieving }
OPDiagramsWidget >> displayFor: aDiagramView [
	^ '[' , aDiagramView name , '] ' , (adapters displayFor: aDiagramView model)
]

{ #category : #initialization }
OPDiagramsWidget >> displayRowFor: aView [
	| name nameMorph modelMorph container |
	name := aView name.
	aView isDefault
		ifTrue: [ name := aView modelName asText allBold ].
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
	adapters := OPNavigatorAdapters new
]

{ #category : #initialization }
OPDiagramsWidget >> initializeList [
	list
		displayBlock: [ :aView | self displayRowFor: aView ];
		icons: [ :aView | adapters iconFor: aView model ];
		doubleClickAction: [ list selectedItem ifNotNil: [ :aView | self openView: aView ] ];
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
OPDiagramsWidget >> initializeWidgets [
	(list := self instantiate: FastTableModel) handlesDoubleClick: true.
	list whenBuiltDo: [ :widget | widget widget disableFunction ].
	self newWidgetHeading.
	toolbar := self instantiate: MenuModel.
	self initializeToolbar
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
OPDiagramsWidget >> openView: aView [
	World showWaitCursorWhile: [ self workbench openEditorOnDiagram: aView ]
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
OPDiagramsWidget >> renameView: aView [
	| name |
	[ name := UIManager default request: 'Rename view "', (self displayFor: aView), '"' initialAnswer: aView name title: 'Rename' ]
		doWhileTrue: [ name isNotNil and: [ name = aView name ] ].
	name ifNil: [ ^ self ].
	aView name: name
]

{ #category : #accessing }
OPDiagramsWidget >> selectedItem [
	^ list selectedItem
]

{ #category : #actions }
OPDiagramsWidget >> selectionChanged: aView [
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
OPDiagramsWidget >> title [
	^ 'Diagram Views'
]

{ #category : #'accessing - spec' }
OPDiagramsWidget >> toolbar [
	^ toolbar
]

{ #category : #actions }
OPDiagramsWidget >> updateContent [
	| views |
	views := self viewsIn: project.
	list items: views.
	views detect: #isSelected ifFound: [ :view | list setSelectedItem: view ]
]

{ #category : #accessing }
OPDiagramsWidget >> viewsIn: aProject [
	^ aProject diagrams
		sorted:
			#modelType ascending , #modelName ascending , [ :each | each isDefault asBit ] descending
				, #name descending
]

{ #category : #'accessing - spec' }
OPDiagramsWidget >> workbench [
	^ owner workbench
]
