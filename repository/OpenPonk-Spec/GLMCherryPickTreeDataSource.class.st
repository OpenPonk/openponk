"
From old iceberg.

I'm a model datasource to handle cherrypick of source changes.
"
Class {
	#name : #GLMCherryPickTreeDataSource,
	#superclass : #GLMFastTreeDataSource,
	#instVars : [
		'selection'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #accessing }
GLMCherryPickTreeDataSource >> cellColumn: column row: rowIndex [
	| item cell |
	item := self elementAt: rowIndex.
	cell := FTIndentedCellMorph new.
	cell indentBy: item depth * 16.
	cell 
		addMorphBack: (self buttonFor: item);
		addMorphBack: (CheckboxButtonMorph new
			selected: (self isSelected: item data);
			target: [ self toggleSelectionOf: item ];
			actionSelector: #value;
			yourself);
		addMorphBack: (self createCellMorphFor: item).

	^ cell
]

{ #category : #'private factory' }
GLMCherryPickTreeDataSource >> createCellMorphFor: item [
	| morph rowElements |

	rowElements := OrderedCollection new.
	(self iconFor: item data) ifNotNil: [ :icon | rowElements add: icon asMorph ].
	rowElements
		add: (self formatedDisplayValueOf: item data) asMorph asReadOnlyMorph;
		addAll: (self tagMorphsFrom: self glamourPresentation for: item data).

	morph := self createInnerCellMorph.
	rowElements do: [ :each | morph addMorphBack: each ].
	^ morph				
]

{ #category : #'private factory' }
GLMCherryPickTreeDataSource >> createInnerCellMorph [
	^ Morph new 
		layoutPolicy: TableLayout new;
		color: Color transparent;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		listDirection: #leftToRight;
		cellPositioning: #leftCenter;
		cellInset: 5;
		listCentering: #leftCenter;
		wrapCentering: #leftCenter;
		yourself
]

{ #category : #private }
GLMCherryPickTreeDataSource >> deselectAllChildrenOf: item [
	(self withAllChildrenOf: item) 
		do: [ :each | selection remove: each data ifAbsent: [] ].
	self tableRefresh
]

{ #category : #initialization }
GLMCherryPickTreeDataSource >> initialize [
	super initialize.
	selection := Set new
]

{ #category : #private }
GLMCherryPickTreeDataSource >> isSelected: anObject [
	^ selection includes: anObject
]

{ #category : #accessing }
GLMCherryPickTreeDataSource >> rootsItems [
	^ rootItem 
		ifNotNil: #children 
		ifNil: [ #() ]
]

{ #category : #updating }
GLMCherryPickTreeDataSource >> selectAll [
	self rootsItems do: [ :each | 
		self selectAllChildrenOf: each ]
]

{ #category : #private }
GLMCherryPickTreeDataSource >> selectAllChildrenOf: item [
	(self withAllChildrenOf: item) 
		do: [ :each | selection add: each data ]
]

{ #category : #accessing }
GLMCherryPickTreeDataSource >> selectAllWithChildren: aCollection [
	selection := Set new.
	aCollection do: [ :each | self selectAllChildrenOf: each ]
]

{ #category : #accessing }
GLMCherryPickTreeDataSource >> selected: aCollection [
	selection := aCollection asSet
]

{ #category : #accessing }
GLMCherryPickTreeDataSource >> selection [
	^ selection
]

{ #category : #private }
GLMCherryPickTreeDataSource >> tableRefresh [
	self table ifNil: [ ^ self ].
	super tableRefresh
]

{ #category : #private }
GLMCherryPickTreeDataSource >> toggleSelectionOf: item [
	(self isSelected: item data) 
		ifTrue: [ self deselectAllChildrenOf: item ]
		ifFalse: [ self selectAllChildrenOf: item ].
	self glamourPresentation cherryPick: selection.
	self tableRefresh

]

{ #category : #updating }
GLMCherryPickTreeDataSource >> updateSelectionWithCollectBlock: aBlock [
	self table ifNil: [ ^ self ].
	super updateSelectionWithCollectBlock: aBlock
]

{ #category : #private }
GLMCherryPickTreeDataSource >> withAllChildrenOf: item [
	^ item children
		inject: { item }
		into: [ :all :each | all, (self withAllChildrenOf: each) ]
]
