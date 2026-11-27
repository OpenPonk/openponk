"
Concrete Spec presenter used within OPShowHidePresenter. Provides a tree view that groups diagram elements by their metamodel types (classes), allowing users to show or hide entire categories of elements at once.
"
Class {
	#name : 'OPTypesShowHidePresenter',
	#superclass : 'OPShowHideTabContentPresenter',
	#instVars : [
		'iconsByTypeNode'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'enumerating' }
OPTypesShowHidePresenter >> allElements [

	^ diagramController allModelElementsWithPossibleController copyWithout: diagramController model
]

{ #category : 'hooks' }
OPTypesShowHidePresenter >> childrenFor: anItem [

	^ anItem showHideChildrenIn: self
]

{ #category : 'private' }
OPTypesShowHidePresenter >> childrenForTypeNode: aTypeNode [

	| childNodes directElements |
	childNodes := aTypeNode children.
	directElements := (self elementsWithTypesInNode: aTypeNode)
		                  select: [ :eachElement |
				                  | elementType |
				                  elementType := viewModelRegistry modelTypeFor: eachElement.
				                  childNodes noneSatisfy: [ :eachChild | eachChild matchesType: elementType ] ]
		                  thenCollect: [ :eachElement | viewModelRegistry viewModelFor: eachElement ].
	^ childNodes asArray , (directElements sorted: [ :firstViewModel :secondViewModel |
		   firstViewModel modelDisplayString < secondViewModel modelDisplayString ])
]

{ #category : 'utilities' }
OPTypesShowHidePresenter >> elementsWithTypesInNode: aNode [

	^ self allElements select: [ :eachElement | aNode matchesType: (viewModelRegistry modelTypeFor: eachElement) ]
]

{ #category : 'initialization' }
OPTypesShowHidePresenter >> expandInitialItemsIn: aRootItem [

	aRootItem children do: [ :eachItem | self expandTypeTreeItem: eachItem ]
]

{ #category : 'initialization' }
OPTypesShowHidePresenter >> expandTypeTreeItem: aTreeItem [

	aTreeItem data shouldExpandInitiallyInTypesTree ifFalse: [ ^ self ].
	aTreeItem expand.
	aTreeItem children do: [ :eachChild | self expandTypeTreeItem: eachChild ]
]

{ #category : 'updating' }
OPTypesShowHidePresenter >> findSelectedItems [

	^ diagramController controllers collect: [ :controller | controller viewModel ] as: Set
]

{ #category : 'hooks' }
OPTypesShowHidePresenter >> iconFor: anItem [

	^ anItem showHideIconIn: self
]

{ #category : 'private' }
OPTypesShowHidePresenter >> iconForTypeNode: aTypeNode [

	aTypeNode parent ifNil: [ ^ diagramController viewModel icon ].
	^ self iconsByTypeNode at: aTypeNode ifAbsentPut: [ self sharedIconForTypeNode: aTypeNode ]
]

{ #category : 'accessing' }
OPTypesShowHidePresenter >> iconsByTypeNode [

	^ iconsByTypeNode ifNil: [ iconsByTypeNode := Dictionary new ]
]

{ #category : 'hooks' }
OPTypesShowHidePresenter >> initialRoots [

	^ { (OPModelObjectTypeRootNode withChildrenFromTypes:
		   (self allElements collect: [ :each | viewModelRegistry modelTypeFor: each ])) }
]

{ #category : 'testing' }
OPTypesShowHidePresenter >> isIcon: firstIcon visuallyEqualTo: secondIcon [

	firstIcon == secondIcon ifTrue: [ ^ true ].
	(firstIcon class == secondIcon class and: [
		 firstIcon extent = secondIcon extent and: [ firstIcon depth = secondIcon depth and: [ firstIcon bits = secondIcon bits ] ] ])
		ifFalse: [ ^ false ].
	^ firstIcon isColorForm not or: [ firstIcon colors = secondIcon colors ]
]

{ #category : 'hooks' }
OPTypesShowHidePresenter >> nameFor: anItem [

	^ anItem showHideName
]

{ #category : 'private' }
OPTypesShowHidePresenter >> selectTypeNode: aTypeNode [

	| elementsToShow executor |
	elementsToShow := self elementsWithTypesInNode: aTypeNode.
	executor := OPDiagramExplorer on: diagramController.
	executor showElements: elementsToShow.
	^ elementsToShow
]

{ #category : 'private' }
OPTypesShowHidePresenter >> selectViewModel: aViewModel [

	| executor |
	executor := OPDiagramExplorer on: diagramController.
	executor showElement: aViewModel model.
	^ { aViewModel model }
]

{ #category : 'hooks' }
OPTypesShowHidePresenter >> selected: aSelectedItem [

	^ aSelectedItem showHideSelectIn: self
]

{ #category : 'testing' }
OPTypesShowHidePresenter >> selectionStateFor: anItem [

	^ anItem showHideSelectionStateIn: self
]

{ #category : 'testing' }
OPTypesShowHidePresenter >> selectionStateForTypeNode: aTypeNode [

	^ self selectionStateForElements: (self elementsWithTypesInNode: aTypeNode)
]

{ #category : 'testing' }
OPTypesShowHidePresenter >> selectionStateForViewModel: aViewModel [

	^ self selectionStateForItem: aViewModel
]

{ #category : 'accessing' }
OPTypesShowHidePresenter >> sharedIconForTypeNode: aTypeNode [

	| matchingIcons firstIcon |
	matchingIcons := (self elementsWithTypesInNode: aTypeNode) collect: [ :eachElement |
		                 (viewModelRegistry viewModelFor: eachElement) icon ].
	matchingIcons ifEmpty: [ ^ Smalltalk ui icons iconNamed: #empty ].
	firstIcon := matchingIcons first.
	^ (matchingIcons allSatisfy: [ :eachIcon | self isIcon: eachIcon visuallyEqualTo: firstIcon ])
		  ifTrue: [ firstIcon ]
		  ifFalse: [ Smalltalk ui icons iconNamed: #empty ]
]

{ #category : 'private' }
OPTypesShowHidePresenter >> unselectTypeNode: aTypeNode [

	| elementsToHide executor |
	elementsToHide := self elementsWithTypesInNode: aTypeNode.
	executor := OPDiagramExplorer on: diagramController.
	executor hideElements: elementsToHide.
	^ elementsToHide
]

{ #category : 'private' }
OPTypesShowHidePresenter >> unselectViewModel: aViewModel [

	| executor |
	executor := OPDiagramExplorer on: diagramController.
	executor hideElement: aViewModel model.
	^ { aViewModel model }
]

{ #category : 'hooks' }
OPTypesShowHidePresenter >> unselected: aRemovedItem [

	^ aRemovedItem showHideUnselectIn: self
]
