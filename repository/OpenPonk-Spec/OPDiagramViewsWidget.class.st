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
		'adapters'
	],
	#classVars : [
		'Icons'
	],
	#category : 'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPDiagramViewsWidget class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #heading height: self toolbarHeight;
		add: #list;
		yourself
]

{ #category : #retrieving }
OPDiagramViewsWidget >> contextMenu: aMenuMorph for: aView [
	aView ifNil: [ ^ aMenuMorph ].
	aMenuMorph
		add: 'Open view'
		target: self
		selector: #openView:
		argument: aView.
	aMenuMorph
		add: 'Clone view ...'
		target: self
		selector: #copyView:
		argument: aView.
	aView isDefault
		ifFalse: [ aMenuMorph
				add: 'Remove view'
				target: self
				selector: #removeView:
				argument: aView ].
	^ aMenuMorph
]

{ #category : #actions }
OPDiagramViewsWidget >> copyView: aView [
	| name newView |
	[ name := UIManager default request: 'View name' initialAnswer: aView name ]
		doWhileTrue: [ name isNotNil and: [ name = aView name ] ].
	name ifNil: [ ^ self ].
	newView := aView newCopy.
	newView name: name.
	self workbench openEditorOnView: newView
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
		menu: [ :menu | self contextMenu: menu for: list selectedItem ]
]

{ #category : #initialization }
OPDiagramViewsWidget >> initializeWidgets [
	(list := self instantiate: FastTableModel)
		handlesDoubleClick: true.
	self newWidgetHeading
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
OPDiagramViewsWidget >> removeView: aView [
	(UIManager default
		confirm: 'Are you sure you want to remove view ' , (self displayFor: aView) , '?')
		ifFalse: [ ^ self ].
	self workbench closeEditorOf: aView.
	aView project: nil.
	self updateContent
]

{ #category : #accessing }
OPDiagramViewsWidget >> selectedItem [
	^ list selectedItem
]

{ #category : #api }
OPDiagramViewsWidget >> title [
	^ 'Diagram Views'
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
