Class {
	#name : #OPTypesShowHidePresenter,
	#superclass : #OPShowHideTabContentPresenter,
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #'as yet unclassified' }
OPTypesShowHidePresenter >> allElements [
	^ diagramController allShowableElements
]

{ #category : #accessing }
OPTypesShowHidePresenter >> childrenFor: aNode [
	^ aNode children
]

{ #category : #defaults }
OPTypesShowHidePresenter >> findSelectedItems [
	| visibleElements hidableElementTypes |
	visibleElements := diagramController allVisibleShowableElements.
	hidableElementTypes := ((adapters allChildrenFor: diagramController model)
									collect: [ :element | element class ]) asSet.
	"Returns all children from getAllNodes x where such visible element exists, that it is hideable and x is its type"
		"The hidability condition excludes OPNote and OPBoundary"
	^ (self getAllNodes
		select: [ :typeTree | 
			visibleElements anySatisfy:
					[ :element | 
						(hidableElementTypes anySatisfy: [:type| type = (element class)])
							and: [typeTree includesType: (diagramController typeOfModel: element)]]])
		ifNotEmpty: [ :newNodes | newNodes copyWith: (OPModelObjectTypeNode named: 'All') ]
]

{ #category : #defaults }
OPTypesShowHidePresenter >> getAllNodes [
	^ self getRootNode withAllChildren
]

{ #category : #defaults }
OPTypesShowHidePresenter >> getRootNode [
	^ OPModelObjectTypeNode
		named: 'All'
		withChildrenFromTypes:
			((adapters allChildrenFor: diagramController model)
				collect: [ :each | diagramController typeOfModel: each ])
]

{ #category : #'as yet unclassified' }
OPTypesShowHidePresenter >> initialRoots [
	^ {self getRootNode}
]

{ #category : #general }
OPTypesShowHidePresenter >> nameFor: aNode [
	^ aNode name
]

{ #category : #'as yet unclassified' }
OPTypesShowHidePresenter >> possibleTypeLeafNames [
	^ self getRootNode leafNames
]

{ #category : #accessing }
OPTypesShowHidePresenter >> selected: added [
	| typesToShow elementsToShow executor |
	typesToShow := added leafNames.
	elementsToShow := self allElements
		select: [ :eachElement | 
			typesToShow
				includes: (diagramController typeOfModel: eachElement) mostSpecificName ].
	executor := OPDiagramExplorer on: diagramController.
	executor showElements: elementsToShow.
	^ elementsToShow
]

{ #category : #'as yet unclassified' }
OPTypesShowHidePresenter >> selectedLeafNames [
	| allTypeLeafNames visibleElements |
	allTypeLeafNames := self possibleTypeLeafNames.
	visibleElements := self allElements
		select: [ :each | diagramController isVisibleInDiagram: each ].
	^ allTypeLeafNames
		select: [ :eachName | 
			visibleElements
				anySatisfy:
					[ :each | (diagramController typeOfModel: each) mostSpecificName = eachName ] ]
]

{ #category : #accessing }
OPTypesShowHidePresenter >> unselected: removed [
	| typesToHide elementsToHide executor |
	typesToHide := removed leafNames.
	elementsToHide := self allElements
		select: [ :eachElement | 
			typesToHide
				includes: (diagramController typeOfModel: eachElement) mostSpecificName ].
	executor := OPDiagramExplorer on: diagramController.
	executor hideElements: elementsToHide.
	^ elementsToHide
]
