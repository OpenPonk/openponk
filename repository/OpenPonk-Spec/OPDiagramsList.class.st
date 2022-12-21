"
I show a list of available diagram views for editing.

Right-clicking on a view shows additional options.
"
Class {
	#name : #OPDiagramsList,
	#superclass : #SpPresenter,
	#instVars : [
		'list',
		'heading',
		'project',
		'toolbar',
		'editButton',
		'deleteButton',
		'openButton',
		'createButton',
		'cloneButton',
		'notebook',
		'adapters'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #'as yet unclassified' }
OPDiagramsList class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpTabLayout new
				   add: #list label: 'Diagrams';
				   yourself);
		  add: #toolbar height: self toolbarHeight;
		  yourself
]

{ #category : #accessing }
OPDiagramsList >> adapters [

	^ adapters ifNil: [ 
		  adapters := self workbench projectController navigatorAdapters ]
]

{ #category : #'as yet unclassified' }
OPDiagramsList >> connectPresenters [
	super connectPresenters.
	self initializeList
]

{ #category : #retrieving }
OPDiagramsList >> contextMenu: aMenuPresenter for: aDiagram [

	aDiagram ifNil: [ ^ aMenuPresenter ].
	aMenuPresenter
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Open diagram';
						action: [ self openDiagram: aDiagram ];
						iconName: #glamorousOpen ];
				addItem: [ :item | 
					item
						name: 'Copy diagram...';
						action: [ self copyDiagram: aDiagram ];
						iconName: #smallCopy ];
				addItem: [ :item | 
					item
						name: 'Rename diagram';
						action: [ self renameDiagram: aDiagram ];
						iconName: #glamorousEdit ] ];
		addGroup: [ :group | 
			group addItem: [ :item | 
				item
					name: 'Delete diagram';
					action: [ self deleteDiagram: aDiagram ];
					iconName: #glamorousTrash;
					enabled: [ self isDeleteAllowedFor: aDiagram ] ] ].
	^ aMenuPresenter
]

{ #category : #actions }
OPDiagramsList >> copyDiagram: aView [
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
OPDiagramsList >> createDiagram [

	| name diagram openModel |
	openModel := self workbench focusedEditor ifNotNil: [ :editor | 
		             editor diagramController model ].
	[ 
	name := UIManager default
		        request: 'Diagram name: '
		        initialAnswer: openModel name
		        title: 'Create new' ] doWhileTrue: [ 
		name isNotNil and: [ name isEmpty ] ].
	name ifNil: [ ^ self ].
	diagram := OPOpenPonkDiagram forModelElement:
		           (openModel ifNil: [ self project models first ]).
	diagram name: name.
	project addDiagram: diagram.
	self workbench openEditorOnDiagram: diagram
]

{ #category : #actions }
OPDiagramsList >> deleteDiagram: aView [
	(UIManager default
		confirm: 'Delete view "' , (self displayFor: aView) , '"?'
		label: 'Delete')
		ifFalse: [ ^ self ].
	self workbench deleteDiagram: aView.
	self updateContent
]

{ #category : #accessing }
OPDiagramsList >> diagramsIn: aProject [
	^ aProject diagrams
		sorted: #modelType ascending , #modelName ascending
]

{ #category : #retrieving }
OPDiagramsList >> displayFor: aDiagramView [

	^ '[' , aDiagramView name , '] '
	  , (self adapters displayFor: aDiagramView model)
]

{ #category : #initialization }
OPDiagramsList >> displayRowFor: aDiagram [

	| name nameMorph modelMorph container modelName |
	name := aDiagram name.
	nameMorph := name asTextMorph lock.
	modelName := (aDiagram modelElement respondsTo: #name)
		             ifTrue: [ aDiagram modelElement name ]
		             ifFalse: [ aDiagram modelElement asString ].
	modelMorph := (' ' , modelName , ' ') asTextMorph
		              lock;
		              color: Color white;
		              backgroundColor: Color veryLightGray;
		              yourself.
	container := OrderedCollection new.
	container
		add: nameMorph;
		add: modelMorph.
	^ self theme newRowIn: self currentWorld for: container
]

{ #category : #'accessing - spec' }
OPDiagramsList >> heading [
	^ heading
]

{ #category : #initialization }
OPDiagramsList >> initializeList [

	list
		display: [ :aView | self displayRowFor: aView ];
		displayIcon: [ :aView | self adapters iconFor: aView modelElement ];
		whenActivatedDo: [ 
			list selectedItem ifNotNil: [ :aView | self openDiagram: aView ] ];
		whenSelectionChangedDo: [ :item | 
			self selectionChanged: item selectedItem ];
		contextMenu: [ 
			self contextMenu: self newMenu for: list selectedItem ]
]

{ #category : #'as yet unclassified' }
OPDiagramsList >> initializePresenters [

	list := self newList.
	list whenBuiltDo: [ :widget | widget widget disableFunction ].
	toolbar := self newMenuBar.
	self initializeToolbar
]

{ #category : #initialization }
OPDiagramsList >> initializeToolbar [
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

{ #category : #actions }
OPDiagramsList >> isDeleteAllowedFor: aDiagram [

	^ project isNotNil and: [ 
		  (project diagramsOf: aDiagram modelElement) size > 1 ]
]

{ #category : #'accessing - spec' }
OPDiagramsList >> list [
	^ list
]

{ #category : #actions }
OPDiagramsList >> openDiagram: aView [
	UIManager default showWaitCursorWhile: [ self workbench openEditorOnDiagram: aView ]
]

{ #category : #accessing }
OPDiagramsList >> project [
	^ project
]

{ #category : #accessing }
OPDiagramsList >> project: aProject [

	project := aProject.
	project whenChanged: [ self updateContent ].
	self withWindowDo: [ :window | window whenClosedDo: [ project unsubscribe: self ] ].
	self updateContent.
	self workbench announcer
		when: OPEditorUnfocused
		do: [ :event | list resetListSelection ].
	self workbench announcer
		when: OPEditorFocused
		do: [ :event | self updateContent ]
]

{ #category : #actions }
OPDiagramsList >> renameDiagram: aView [

	| name |
	[ 
	name := UIManager default
		        request: 'Rename view "' , (self displayFor: aView) , '"'
		        initialAnswer: aView name
		        title: 'Rename' ] doWhileTrue: [ 
		name isNotNil and: [ name = aView name ] ].
	name ifNil: [ ^ self ].
	aView name: name.
	list updateList
]

{ #category : #actions }
OPDiagramsList >> selectedDiagram: aDiagram [
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
OPDiagramsList >> selectedItem [
	^ list selectedItem
]

{ #category : #actions }
OPDiagramsList >> selectionChanged: aDiagram [
	aDiagram ifNil: [ ^ self unselectedDiagram ].
	self selectedDiagram: aDiagram
]

{ #category : #'accessing - spec' }
OPDiagramsList >> toolbar [
	^ toolbar
]

{ #category : #actions }
OPDiagramsList >> unselectedDiagram [
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
OPDiagramsList >> updateContent [

	| diagrams |
	diagrams := self diagramsIn: project.
	list items: diagrams.
	diagrams
		detect: #isSelected
		ifFound: [ :view | list selectItem: view ]
]

{ #category : #'accessing - spec' }
OPDiagramsList >> workbench [
	^ owner workbench
]
