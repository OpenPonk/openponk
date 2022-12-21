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
		'selectedTool',
		'selectedItem',
		'diagramController',
		'items'
	],
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #'as yet unclassified' }
OPPalette class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
]

{ #category : #'widget API' }
OPPalette class >> initialWidth [

	^ 180
]

{ #category : #'widget API' }
OPPalette class >> minWidth [

	^ 120
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
	diagramController whenAllDeselectedDo: [ self selectSelectionTool ]
]

{ #category : #'building widgets' }
OPPalette >> createWidgets [
	items do: [ :item | self assign: item to: ('button' , item hash asString) asSymbol ]
]

{ #category : #private }
OPPalette >> deselectTool [

	self
		deprecated: 'Use #selectSelectionTool instead.'
		transformWith:
		'`@receiver deselectTool' -> '`@receiver selectSelectionTool'.
	^ self selectSelectionTool
]

{ #category : #accessing }
OPPalette >> diagramController [
	^ diagramController
]

{ #category : #accessing }
OPPalette >> editor [
	^ self owner
]

{ #category : #accessing }
OPPalette >> entries [

	^ self items select: [ :each | each isKindOf: OPPaletteEntry ]
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
	itemsLayout := self class defaultLayout.
	itemsLayout spacing: 2.
	items do: [ :each | itemsLayout add: each expand: false ].
	self layout: itemsLayout
]

{ #category : #initialization }
OPPalette >> initializePresenters [
	self newSelectionTool.
	self newSeparator
]

{ #category : #accessing }
OPPalette >> items [
	^ items
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
		icon: OPCoreIcons opSelectIcon
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
