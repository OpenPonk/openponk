"
I am an editor for UML DSL.
"
Class {
	#name : #OPDslEditor,
	#superclass : #ComposablePresenter,
	#instVars : [
		'editor',
		'autoUpdate',
		'toolbar',
		'location',
		'model',
		'parser',
		'exporter',
		'errorAttribute',
		'textAttribute',
		'modelClass',
		'highlighter'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPDslEditor class >> defaultSpec [
	^ SpecColumnLayout new
		newRow: [ :row | row add: #toolbar ] height: self toolbarHeight;
		newRow: [ :row | row add: #editor ];
		newRow: [ :row | row add: #autoUpdate ] height: self toolbarHeight;
		yourself
]

{ #category : #'accessing - spec' }
OPDslEditor >> autoUpdate [
	^ autoUpdate
]

{ #category : #initialization }
OPDslEditor >> buildToolbar: aMenu [
	aMenu
		addGroup:
			[ :group | 
			group
				addItem:
						[ :item | 
					item
						name: 'New';
						description: 'New Diagram';
						icon: (self iconNamed: #addIcon);
						action: [ self class new openWithSpec ] ];
				addItem:
						[ :item | 
					item
						name: 'Save';
						description: 'Save Diagram';
						icon: (self iconNamed: #smallSaveIcon);
						action: [ self saveToFile: location ] ];
				addItem:
						[ :item | 
					item
						name: 'Save as...';
						description: 'Save Diagram As...';
						icon: (self iconNamed: #smallSaveIcon);
						action: [ self saveToFile: nil ] ];
				addItem:
						[ :item | 
					item
						name: 'Open';
						description: 'Open...';
						icon: (self iconNamed: #openIcon);
						action: [ self openFromFile ] ];
				addItem:
						[ :item | 
					item
						name: 'Open Editor';
						description: 'Open Editor';
						icon: (self iconNamed: #openIcon);
						action: [ model ifNil: [ self updateModel ].
							OPWorkbench openModel: model ] ] ]
]

{ #category : #'accessing - spec' }
OPDslEditor >> editor [
	^ editor
]

{ #category : #accessing }
OPDslEditor >> exporter [
	^ exporter
]

{ #category : #accessing }
OPDslEditor >> exporter: anExporter [
	exporter := anExporter
]

{ #category : #'accessing - spec' }
OPDslEditor >> highlight: aText [
	| tokens |
	highlighter ifNil: [ ^ aText ].
	tokens := (highlighter parse: aText) flattened.
	tokens flattened
		select: [ :each | each isKindOf: Association ]
		thenDo: [ :each | 
			((each key isKindOf: Association) and: [ each value isKindOf: Association ])
				ifTrue: [ aText makeColor: each key value from: each key key start to: each key key stop.
					aText makeColor: each value value from: each value key start to: each value key stop ]
				ifFalse: [ aText makeColor: each value from: each key start to: each key stop ] ]
]

{ #category : #'accessing - spec' }
OPDslEditor >> highlighter: aHighlighterParser [
	highlighter := aHighlighterParser
]

{ #category : #initialization }
OPDslEditor >> initializePresenter [
	super initializePresenter.
	editor whenTextIsAccepted: [ self textUpdated: editor text ]
]

{ #category : #initialization }
OPDslEditor >> initializeWidgets [
	toolbar := self instantiate: MenuModel.
	self buildToolbar: toolbar.
	toolbar applyTo: self.
	(editor := self newText)
		isCodeCompletionAllowed: true;
		whenBuiltDo: [ :w | w widget withLineNumbers ].
	(autoUpdate := self newButton)
		label: 'Refresh from Model';
		action: [ self updateFromModel ].
	self focusOrder
		add: editor;
		add: autoUpdate
]

{ #category : #accessing }
OPDslEditor >> model: aModel [
	model := aModel
]

{ #category : #accessing }
OPDslEditor >> modelClass [
	^ modelClass
]

{ #category : #accessing }
OPDslEditor >> modelClass: aModelClass [
	modelClass := aModelClass
]

{ #category : #'instance creation' }
OPDslEditor >> newModel [
	^ self modelClass new
]

{ #category : #'save/load' }
OPDslEditor >> openFromFile [
	| filename |
	filename := UITheme builder fileOpen: 'Choose a .txt file' extensions: #('txt').
	filename ifNil: [ ^ self ].
	location := filename name asFileReference.
	editor text: location contents
]

{ #category : #accessing }
OPDslEditor >> parser [
	^ parser
]

{ #category : #accessing }
OPDslEditor >> parser: aParser [
	parser := aParser
]

{ #category : #'save/load' }
OPDslEditor >> saveToFile: aPath [
	| newLocation |
	newLocation := aPath.
	newLocation
		ifNil: [ newLocation := UITheme builder fileSave: 'Save to .txt file' extensions: #('txt') ].
	newLocation ifNil: [ ^ self ].
	location := newLocation.
	location ensureDelete.
	location writeStream nextPutAll: editor text.
	self updateModel
]

{ #category : #'event handling' }
OPDslEditor >> textUpdated: aString [
	location ifNil: [ self updateModel ] ifNotNil: [ self saveToFile: location ]
]

{ #category : #api }
OPDslEditor >> title [
	^ 'DSL Editor'
]

{ #category : #'accessing - spec' }
OPDslEditor >> toolbar [
	^ toolbar
]

{ #category : #'event handling' }
OPDslEditor >> updateFromModel [
	| text |
	model ifNil: [ ^ self ].
	text := (self exporter export: model) asText.
	self highlight: text.
	editor text: text
]

{ #category : #'event handling' }
OPDslEditor >> updateModel [
	| statements text toks |
	model ifNil: [ model := self newModel ].
	text := editor text.
	text makeAllColor: Smalltalk ui theme textColor.
	statements := self parser class new parseStatements: text asString.
	statements isPetitFailure
		ifTrue: [ text asPetitStream newlines
				overlappingPairsDo: [ :start :end | 
					(statements position between: start and: end)
						ifTrue: [ text makeColor: Color red from: (1 max: start) to: end ] ] ]
		ifFalse: [ parser replaceModel: model withStatements: statements.
			self highlight: text ].
	editor text: text.
	model announcer announce: (OPModelContentReplaced model: model)
]
