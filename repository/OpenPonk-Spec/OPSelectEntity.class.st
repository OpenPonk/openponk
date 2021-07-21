"
A to-1 relationship field with keyboard selection with entry completion and a separate dialog for detailed searching (and creating new entities)

!! NOTE

This is a direct copy of SelectEntity from the Ancestry project. It is available by default in Pharo 6, so I copied it to avoid extra dependency
"
Class {
	#name : #OPSelectEntity,
	#superclass : #ComposablePresenter,
	#instVars : [
		'entity',
		'selectEntity',
		'possibleEntities',
		'selectDialogBlock',
		'displaySymbol',
		'entityText',
		'ghostText',
		'selectDialog'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPSelectEntity class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				add: #entityText;
				add: #selectEntity width: 25 ];
		yourself
]

{ #category : #example }
OPSelectEntity class >> example [
	SelectEntity new
		selectDialog: [ FastTableModel new items: #(Henrik Peter); yourself];
		displaySymbol: #asString;
		ghostText: 'Names';
		possibleEntities: [#(Diego Stephan Norbert Stephane Marcus Torsten Sven Sean) sorted];
		openDialogWithSpec 

]

{ #category : #specs }
OPSelectEntity class >> specLayout [
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				add: #entityText;
				add: #selectEntity width: 25 ];
		yourself
]

{ #category : #api }
OPSelectEntity >> displaySymbol [
	"<api: #inspect>"
	"return the method selector used to get the label of the entity that is for entry completion"
	^ displaySymbol value ifNil: [ #printString ]
]

{ #category : #api }
OPSelectEntity >> displaySymbol: anObject [
	displaySymbol value: anObject.
	entityText entryCompletion: self entitiesEntryCompletion.
]

{ #category : #entryCompletion }
OPSelectEntity >> entitiesEntryCompletion [
	^ EntryCompletion new
				dataSourceBlock: [:currText | self possibleEntities collect: [:each | 
		each perform: self displaySymbol ]];
				chooseBlock: [ :selectedName | 
					self entity: (self possibleEntities detect: [ :each | 
						(each perform: self displaySymbol) = selectedName ])];
				filterBlock: [:currEntity :currText | 
					currEntity asUppercase includesSubstring: currText asString asUppercase].
]

{ #category : #api }
OPSelectEntity >> entity [
	
	^ entity value
]

{ #category : #api }
OPSelectEntity >> entity: anObject [
	entity value: anObject.
	anObject ifNotNil: [  
		self entityText text: (anObject perform: self displaySymbol)] ifNil: [ self entityText text: '' ]
]

{ #category : #accessing }
OPSelectEntity >> entityText [
	^ entityText
]

{ #category : #accessing }
OPSelectEntity >> entityText: anObject [
	entityText := anObject
]

{ #category : #api }
OPSelectEntity >> ghostText [
	^ ghostText value ifNil: [ '' ]
]

{ #category : #api }
OPSelectEntity >> ghostText: aString [
	ghostText value: aString.
	entityText ghostText: aString
]

{ #category : #initialization }
OPSelectEntity >> initialize [
	super initialize.
	self initializeValueHolders
]

{ #category : #initialization }
OPSelectEntity >> initializePresenter [
	selectEntity 
		action: [  |select|
			select := self selectDialog value.
			select openDialogWithSpec
				okAction: [  
					self entity: select selectedItem ]]

]

{ #category : #initialization }
OPSelectEntity >> initializeValueHolders [
	displaySymbol := #displayString asValueHolder.
	entity := nil asValueHolder.
	ghostText := 'Choose one' asValueHolder.
	possibleEntities := #() asValueHolder.
	selectDialog := [  ] asValueHolder
]

{ #category : #initialization }
OPSelectEntity >> initializeWidgets [
	entityText := self newTextInput
		ghostText: self ghostText;
		autoAccept: true;
		entryCompletion: self entitiesEntryCompletion;
		yourself.
	selectEntity := self newButton
		icon: Smalltalk ui icons glamorousSearch;
		help: 'Open a selection dialog'.
	self focusOrder
		add: entityText;
		add: selectEntity
]

{ #category : #api }
OPSelectEntity >> possibleEntities [
	possibleEntities value ifNil: [ ^#() ]
		ifNotNil: [ ^possibleEntities value value ]
]

{ #category : #api }
OPSelectEntity >> possibleEntities: aBlock [
	"<api: #block getter: #possibleEntities registration: #whenPossibleEntitiesChanged:>"
	"Set the block used to return a collection of all possible entity choices"
	possibleEntities value: aBlock.
	entityText entryCompletion: self entitiesEntryCompletion.
]

{ #category : #api }
OPSelectEntity >> selectDialog [
	^ selectDialog value
]

{ #category : #api }
OPSelectEntity >> selectDialog: anObject [
	"<api: #block getter: #selectDialog registration: #whenSelectDialogChanged:>"
	"Set a block that returns an object that will 
	first be sent #openDialogWithSpec
	and then as okAction sent #selectedItem"
	selectDialog value: anObject
]

{ #category : #accessing }
OPSelectEntity >> selectEntity [
	^ selectEntity
]

{ #category : #accessing }
OPSelectEntity >> selectEntity: anObject [
	selectEntity := anObject
]

{ #category : #'api-events' }
OPSelectEntity >> whenDisplaySymbolChanged: aBlock [
	displaySymbol whenChangedDo: aBlock
]

{ #category : #'api-events' }
OPSelectEntity >> whenEntityChanged: aBlock [
	entity whenChangedDo: aBlock
]

{ #category : #'api-events' }
OPSelectEntity >> whenGhostTextChanged: aBlock [
	ghostText whenChangedDo: aBlock
]

{ #category : #'api-events' }
OPSelectEntity >> whenPossibleEntitiesChanged: aBlock [
	possibleEntities whenChangedDo: aBlock
]

{ #category : #'api-events' }
OPSelectEntity >> whenSelectDialogChanged: aBlock [
	selectDialog whenChangedDo: aBlock
]
