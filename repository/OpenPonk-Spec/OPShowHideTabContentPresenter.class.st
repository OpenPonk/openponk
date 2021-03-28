Class {
	#name : #OPShowHideTabContentPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'diagramController',
		'tree',
		'selectedItems',
		'adapters'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #specs }
OPShowHideTabContentPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #tree;
		yourself
]

{ #category : #accessing }
OPShowHideTabContentPresenter >> childrenFor: anItem [
	^ self subclassResponsibility
]

{ #category : #initialization }
OPShowHideTabContentPresenter >> connectPresenters [
	self whenSelectionChangedDo: [ self updateSelectedItems ]
]

{ #category : #'as yet unclassified' }
OPShowHideTabContentPresenter >> findSelectedItems [
	^ self subclassResponsibility
]

{ #category : #defaults }
OPShowHideTabContentPresenter >> hasIcon [
	^ self class includesSelector: #iconFor:
]

{ #category : #defaults }
OPShowHideTabContentPresenter >> iconFor: anItem [
	^ nil
]

{ #category : #'as yet unclassified' }
OPShowHideTabContentPresenter >> initialRoots [
	^ self subclassResponsibility
]

{ #category : #initialization }
OPShowHideTabContentPresenter >> initializePresenters [
	| mainColumn |
	tree := self newTreeTable.
	mainColumn := SpCompositeTableColumn new.
	mainColumn
		addColumn:
			((SpCheckBoxTableColumn
				evaluated: [ :modelObject | self isSelected: modelObject ])
				width: 20;
				onActivation: [ :modelObject | self processAndUpdateSelected: modelObject ];
				onDesactivation: [ :modelObject | self processAndUpdateUnselected: modelObject ];
				yourself).
	self hasIcon
		ifTrue: [ mainColumn
				addColumn:
					((SpImageTableColumn
						evaluated: [ :modelObject | self iconFor: modelObject ])
						width: 20;
						yourself) ].
	mainColumn
		addColumn:
			(SpStringTableColumn
				evaluated: [ :modelObject | self nameFor: modelObject ]).
	tree
		addColumn: mainColumn;
		roots: self initialRoots;
		hideColumnHeaders;
		children: [ :item | self childrenFor: item ];
		whenBuiltDo: [ :buildWidget | buildWidget widget dataSource rootItem expandAll ]
]

{ #category : #testing }
OPShowHideTabContentPresenter >> isSelected: anItem [
	^ self selectedItems includes: anItem
]

{ #category : #general }
OPShowHideTabContentPresenter >> nameFor: anItem [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPShowHideTabContentPresenter >> processAndUpdateSelected: anAddedItem [
	| addedElements |
	addedElements := self selected: anAddedItem.
	self announcer
		announce: (OPShowHideElementsSelected elements: addedElements)
]

{ #category : #accessing }
OPShowHideTabContentPresenter >> processAndUpdateUnselected: aRemovedItem [
	| removedElements |
	removedElements := self unselected: aRemovedItem.
	self announcer
		announce: (OPShowHideElementsUnselected elements: removedElements)
]

{ #category : #accessing }
OPShowHideTabContentPresenter >> selected: anAddedItem [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPShowHideTabContentPresenter >> selectedItems [
	^ selectedItems ifNil: [ self updateSelectedItems ]
]

{ #category : #'accessing model' }
OPShowHideTabContentPresenter >> setModelBeforeInitialization: aDiagramController [
	diagramController := aDiagramController.
	adapters := OPNavigatorAdapters default
]

{ #category : #accessing }
OPShowHideTabContentPresenter >> unselected: aRemovedItem [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPShowHideTabContentPresenter >> updateSelectedItems [
	selectedItems := self findSelectedItems.
	tree adapter
		ifNotNil: [ :treeAdapter | 
			treeAdapter widget dataSource
				updateData;
				expandAll ].
	^ selectedItems
]

{ #category : #enumerating }
OPShowHideTabContentPresenter >> whenSelectionChangedDo: aBlock [
	^ self announcer when: OPShowHideSelectionChanged do: aBlock
]
