"
Concrete Spec presenter used within OPShowHidePresenter. Provides a tree view that groups diagram elements by their metamodel types (classes), allowing users to show or hide entire categories of elements at once.
"
Class {
	#name : 'OPTypesShowHidePresenter',
	#superclass : 'OPShowHideTabContentPresenter',
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'accessing' }
OPTypesShowHidePresenter >> allElements [
	^ diagramController allModelElementsWithPossibleController
]

{ #category : 'accessing' }
OPTypesShowHidePresenter >> childrenFor: aNode [
	^ aNode children
]

{ #category : 'defaults' }
OPTypesShowHidePresenter >> findSelectedItems [
    | visibleElements hidableElementTypes |
    visibleElements := diagramController allModelElementsWithController.
    hidableElementTypes := (diagramController allModelElementsWithPossibleController
                                    collect: [ :element | element class ]) asSet.
    ^ (self getAllNodes
        select: [ :typeTree | 
            visibleElements anySatisfy: [ :element | 
                (hidableElementTypes anySatisfy: [:type| type = element class ])
                    and: [ typeTree includesType: (diagramController typeOfModel: element) ] ] ])
        ifNotEmpty: [ :newNodes | newNodes copyWith: (OPModelObjectTypeNode named: 'All') ]
]

{ #category : 'defaults' }
OPTypesShowHidePresenter >> getAllNodes [
	^ self getRootNode withAllChildren
]

{ #category : 'defaults' }
OPTypesShowHidePresenter >> getRootNode [
	^ OPModelObjectTypeNode
		named: 'All'
		withChildrenFromTypes:
			((viewModelRegistry allChildrenFor: diagramController model)
				collect: [ :each | diagramController typeOfModel: each ])
]

{ #category : 'accessing' }
OPTypesShowHidePresenter >> initialRoots [
	^ {self getRootNode}
]

{ #category : 'general' }
OPTypesShowHidePresenter >> nameFor: aNode [
	^ aNode name
]

{ #category : 'accessing' }
OPTypesShowHidePresenter >> possibleTypeLeafNames [
	^ self getRootNode leafNames
]

{ #category : 'accessing' }
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

{ #category : 'accessing' }
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

{ #category : 'accessing' }
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
