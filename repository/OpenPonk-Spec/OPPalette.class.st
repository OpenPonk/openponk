"
I am a container and manager for palette entries. I am added as part of DCEditor.

!! Responsibility

Be a container for entries.
Manage changes between tools.

!! Collaborators

DCPaletteEntry
DCPaletteTool
DCEditor

"
Class {
	#name : #OPPalette,
	#superclass : #SpPresenter,
	#instVars : [
		'items',
		'selectedTool',
		'selectedItem',
		'diagramController'
	],
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #'as yet unclassified' }
OPPalette class >> defaultLayout [

	self flag: 'Pharo 9- compatibility'.
	^ SpBoxLayout newTopToBottom
]

{ #category : #specs }
OPPalette class >> defaultSpec [

	self flag: 'Pharo 9- compatibility'.
	^ self defaultLayout
]

{ #category : #private }
OPPalette >> addEntry [
	| entry |
	entry := self instantiate: OPPaletteEntry.
	items add: entry.
	^ entry
]

{ #category : #'building widgets' }
OPPalette >> alignButtons [
	"align content of all buttons to left"

	items
		select: [ :each | (each isKindOf: OPPaletteEntry) and: [ each widget isNotNil ] ]
		thenDo: [ :each | each widget widget submorphs first listCentering: #topLeft ]
]

{ #category : #protocol }
OPPalette >> createPaletteFor: aDiagramController [

	diagramController := aDiagramController.
	self removeAll.
	OPPaletteInitializer
		addAllToPalette: self
		forController: diagramController.
	self selectSelectionTool.
	diagramController whenAllDeselectedDo: [ self deselectTool ]
]

{ #category : #'building widgets' }
OPPalette >> createWidgets [
	items do: [ :item | self assign: item to: ('button' , item hash asString) asSymbol ]
]

{ #category : #private }
OPPalette >> deselectTool [
	self selectSelectionTool
]

{ #category : #accessing }
OPPalette >> diagramController [
	^ diagramController
]

{ #category : #'building widgets' }
OPPalette >> dynamicLayout [
	| keys |
	keys := self widgets keys.
	^ SpBoxLayout newLeftToRight
		add: SpBoxLayout newTopToBottom:  [ :c | 
			c add: #heading height: self class toolbarHeight.
			keys do: [ :key | c add: SpBoxLayout newLeftToRight:  key height: self class buttonHeight ].
			c add: SpBoxLayout newLeftToRight:  [ :r |  ] ];
		yourself
]

{ #category : #accessing }
OPPalette >> editor [
	^ self owner
]

{ #category : #accessing }
OPPalette >> entries [
	^ items
]

{ #category : #initialization }
OPPalette >> initialize [

	items := OrderedCollection new.
	super initialize.
	self
		bindKeyCombination: Character escape
		toAction: [ self selectSelectionTool ]
]

{ #category : #'building widgets' }
OPPalette >> initializeLayout [

	| itemsLayout |
	itemsLayout := SpBoxLayout newTopToBottom.
	items do: [ :each | itemsLayout add: each ].
	self layout: (SpTabLayout new
			 add: (items
					  ifEmpty: [ self newNullPresenter ]
					  ifNotEmpty: [ SpScrollableLayout with: items ])
			 label: 'Palette';
			 yourself)
]

{ #category : #'as yet unclassified' }
OPPalette >> initializePresenters [
	self newSelectionTool.
	self newSeparator
]

{ #category : #protocol }
OPPalette >> newConnectionCreationEntry: aFactoryBlock [
	| entry |
	entry := self addEntry.
	entry tool: (OPConnectionCreationTool new palette: self).
	entry factory: aFactoryBlock.
	^ entry
]

{ #category : #protocol }
OPPalette >> newConnectionCreationTool: aFactoryBlock [
	| item tool |
	item := self addEntry.
	(tool := OPConnectionCreationTool new)
		palette: self;
		factory: aFactoryBlock.
	item action: [ self selectItem: item tool: tool ].
	^ item
]

{ #category : #protocol }
OPPalette >> newConnectionCreationTool: aLabel factory: aBlock [
	self newConnectionCreationTool: aLabel factory: aBlock icon: nil
]

{ #category : #protocol }
OPPalette >> newConnectionCreationTool: aLabel factory: aBlock icon: anIcon [
	| item tool |
	item := self addEntry.
	(tool := OPConnectionCreationTool new)
		palette: self;
		factory: aBlock.
	item
		label: aLabel;
		icon: anIcon;
		action: [ self selectItem: item tool: tool ]
]

{ #category : #protocol }
OPPalette >> newCreationEntry: aFactoryBlock [
	| entry |
	entry := self addEntry.
	entry tool: (OPCreationTool new palette: self).
	entry factory: aFactoryBlock.
	^ entry
]

{ #category : #protocol }
OPPalette >> newCreationTool: aFactoryBlock [
	| item tool |
	item := self addEntry.
	(tool := OPCreationTool new)
		palette: self;
		factory: aFactoryBlock.
	item action: [ self selectItem: item tool: tool ].
	^ item
]

{ #category : #protocol }
OPPalette >> newCreationTool: aLabel factory: aBlock [
	self newCreationTool: aLabel factory: aBlock icon: nil
]

{ #category : #protocol }
OPPalette >> newCreationTool: aLabel factory: aBlock icon: anIcon [
	| item tool |
	item := self addEntry.
	(tool := OPCreationTool new)
		palette: self;
		factory: aBlock.
	item
		label: aLabel;
		icon: anIcon;
		action: [ self selectItem: item tool: tool ]
]

{ #category : #protocol }
OPPalette >> newCreationTool: aFactoryBlock with: aToolConfigBlock [
	| item tool |
	item := self addEntry.
	(tool := OPCreationTool new)
		palette: self;
		factory: aFactoryBlock.
	item action: [ self selectItem: item tool: tool ].
	aToolConfigBlock value: tool.
	^ item
]

{ #category : #protocol }
OPPalette >> newModelCreationTool: aFactoryBlock [
	| entry |
	entry := self addEntry.
	entry tool: (OPModelCreationTool new palette: self).
	entry factory: aFactoryBlock.
	^ entry
]

{ #category : #private }
OPPalette >> newSelectionTool [
	| item tool |
	item := self addEntry.
	(tool := OPSelectionTool new) palette: self.
	item
		label: 'Select';
		action: [ self selectItem: item tool: tool ];
		shortcut: Character escape asKeyCombination;
		icon: OPIcons current dcSelectIcon
]

{ #category : #protocol }
OPPalette >> newSeparator [
	| item |
	item := self newLabel.
	items add: item
]

{ #category : #'building widgets' }
OPPalette >> rebuildWidget [

	self initializeLayout
]

{ #category : #removing }
OPPalette >> removeAll [
	items := OrderedCollection new.
	self initializePresenters
]

{ #category : #private }
OPPalette >> selectEntry: anEntry [
	selectedTool
		ifNotNil: [ selectedTool deselect.
			selectedItem state: false ].
	selectedTool := anEntry tool.
	selectedItem := anEntry.
	anEntry select
]

{ #category : #private }
OPPalette >> selectItem: anItem tool: aTool [
	selectedTool
		ifNotNil: [ 
			selectedTool deselect.
			selectedItem state: false ].
	(selectedTool := aTool) select.
	(selectedItem := anItem) state: true
]

{ #category : #private }
OPPalette >> selectSelectionTool [
	items first performAction
]

{ #category : #private }
OPPalette >> selectTool: aTool [
	selectedTool
		ifNotNil: [ selectedTool deselect.
			selectedItem state: false ].
	(selectedTool := aTool) select
]

{ #category : #private }
OPPalette >> selectedTool [
	^ selectedTool
]

{ #category : #accessing }
OPPalette >> workbench [
	^ self editor workbench
]
