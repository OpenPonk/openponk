"
Abstract base Spec presenter for the individual tab pages within OPShowHidePresenter. 
Manages a tree view with checkboxes to track which diagram elements are selected for visibility.
"
Class {
	#name : 'OPShowHideTabContentPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'diagramController',
		'tree',
		'selectedItems',
		'viewModelRegistry'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'layout' }
OPShowHideTabContentPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #tree;
		  yourself
]

{ #category : 'accessing' }
OPShowHideTabContentPresenter >> childrenFor: anItem [
	^ self subclassResponsibility
]

{ #category : 'initialization' }
OPShowHideTabContentPresenter >> connectPresenters [

	self whenSelectionChangedDo: [ self updateSelectedItems ]
]

{ #category : 'defaults' }
OPShowHideTabContentPresenter >> findSelectedItems [
	^ self subclassResponsibility
]

{ #category : 'defaults' }
OPShowHideTabContentPresenter >> hasIcon [
	^ self class includesSelector: #iconFor:
]

{ #category : 'defaults' }
OPShowHideTabContentPresenter >> iconFor: anItem [
	^ nil
]

{ #category : 'accessing' }
OPShowHideTabContentPresenter >> initialRoots [
	^ self subclassResponsibility
]

{ #category : 'initialization' }
OPShowHideTabContentPresenter >> initializePresenters [

	| mainColumn |
	tree := self newTreeTable.
	mainColumn := SpCompositeTableColumn new.
	mainColumn addColumn:
		((SpCheckBoxTableColumn evaluated: [ :modelObject |
				  self isSelected: modelObject ])
			 width: 20;
			 onActivation: [ :modelObject |
				 self processAndUpdateSelected: modelObject ];
			 onDeactivation: [ :modelObject |
				 self processAndUpdateUnselected: modelObject ];
			 yourself).
	self hasIcon ifTrue: [
		mainColumn addColumn:
			((SpImageTableColumn evaluated: [ :modelObject |
					  self iconFor: modelObject ])
				 width: 20;
				 yourself) ].
	mainColumn addColumn:
		(SpStringTableColumn evaluated: [ :modelObject |
			 self nameFor: modelObject ]).
	tree
		addColumn: mainColumn;
		roots: self initialRoots;
		hideColumnHeaders;
		children: [ :item | self childrenFor: item ];
		whenBuiltDo: [ :buildWidget |
			buildWidget widget dataSource rootItem expandAll ];
		searchMatching: [ :item :pattern |
			(self nameFor: item) asString trimBoth asLowercase includesSubstring:
					pattern asLowercase ]
]

{ #category : 'testing' }
OPShowHideTabContentPresenter >> isSelected: anItem [
	^ self selectedItems includes: anItem
]

{ #category : 'general' }
OPShowHideTabContentPresenter >> nameFor: anItem [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPShowHideTabContentPresenter >> processAndUpdateSelected: anAddedItem [
	| addedElements |
	addedElements := self selected: anAddedItem.
	self announcer
		announce: (OPShowHideElementsSelected elements: addedElements)
]

{ #category : 'accessing' }
OPShowHideTabContentPresenter >> processAndUpdateUnselected: aRemovedItem [
	| removedElements |
	removedElements := self unselected: aRemovedItem.
	self announcer
		announce: (OPShowHideElementsUnselected elements: removedElements)
]

{ #category : 'accessing' }
OPShowHideTabContentPresenter >> selected: anAddedItem [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPShowHideTabContentPresenter >> selectedItems [
	^ selectedItems ifNil: [ self updateSelectedItems ]
]

{ #category : 'accessing - model' }
OPShowHideTabContentPresenter >> setModelBeforeInitialization: aDiagramController [
    diagramController := aDiagramController.
    viewModelRegistry := diagramController editor workbench projectController viewModelRegistry
]

{ #category : 'accessing' }
OPShowHideTabContentPresenter >> unselected: aRemovedItem [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPShowHideTabContentPresenter >> updateSelectedItems [

	selectedItems := self findSelectedItems.
	tree refresh.
	^ selectedItems
]

{ #category : 'enumerating' }
OPShowHideTabContentPresenter >> whenSelectionChangedDo: aBlock [

	^ self announcer
		  when: OPShowHideSelectionChanged
		  do: aBlock
		  for: (aBlock receiver ifNil: [ self ])
]
