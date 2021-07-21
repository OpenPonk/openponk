"
I show a list of available diagrams for editing.
"
Class {
	#name : #OPDiagramWidget,
	#superclass : #ComposablePresenter,
	#instVars : [
		'list',
		'heading',
		'project',
		'adapters'
	],
	#classVars : [
		'Icons'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPDiagramWidget class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #heading height: self toolbarHeight;
		add: #list;
		yourself
]

{ #category : #accessing }
OPDiagramWidget >> diagramsIn: aProject [
	^ aProject models
		sorted: [ :a :b | 
			a class name = b class name
				ifTrue: [ a name < b name ]
				ifFalse: [ a class name < b class name ] ]
]

{ #category : #'accessing - spec' }
OPDiagramWidget >> heading [
	^ heading
]

{ #category : #initialization }
OPDiagramWidget >> initialize [
	super initialize.
	adapters := OPNavigatorAdapters default
]

{ #category : #initialization }
OPDiagramWidget >> initializePresenter [
	super initializePresenter.
	list
		displayBlock: [ :aModel | adapters displayFor: aModel ];
		icons: [ :aModel | adapters iconFor: aModel ];
		doubleClickAction: [ list selectedItem ifNotNil: [ :aModel | self openModel: aModel ] ]
]

{ #category : #initialization }
OPDiagramWidget >> initializeWidgets [
	(list := self instantiate: FastTableModel)
		handlesDoubleClick: true.
	self newWidgetHeading
]

{ #category : #'accessing - spec' }
OPDiagramWidget >> list [
	^ list
]

{ #category : #initialization }
OPDiagramWidget >> newWidgetHeading [
	heading := OPWidgetHeading forLabel: self title
]

{ #category : #actions }
OPDiagramWidget >> openDiagram: aModel [
	UIManager default showWaitCursorWhile: [ self workbench openEditorOn: aModel ]
]

{ #category : #actions }
OPDiagramWidget >> openModel: aModel [
	UIManager default showWaitCursorWhile: [ self workbench openEditorOn: aModel ]
]

{ #category : #accessing }
OPDiagramWidget >> project [
	^ project
]

{ #category : #accessing }
OPDiagramWidget >> project: aProject [
	project := aProject.
	list items: (self diagramsIn: aProject).
	project whenChanged: [ list items: (self diagramsIn: aProject) ]
]

{ #category : #api }
OPDiagramWidget >> title [
	^ 'Diagrams'
]

{ #category : #'accessing - spec' }
OPDiagramWidget >> workbench [
	^ owner workbench
]
