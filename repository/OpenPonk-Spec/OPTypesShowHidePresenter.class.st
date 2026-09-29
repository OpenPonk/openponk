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

{ #category : 'enumerating' }
OPTypesShowHidePresenter >> allElements [

	^ diagramController allModelElementsWithPossibleController copyWithout: diagramController model
]

{ #category : 'hooks' }
OPTypesShowHidePresenter >> childrenFor: aNode [

	^ aNode children
]

{ #category : 'utilities' }
OPTypesShowHidePresenter >> elementsWithTypesInNode: aNode [

	^ self allElements select: [ :eachElement | aNode matchesType: (viewModelRegistry modelTypeFor: eachElement) ]
]

{ #category : 'updating' }
OPTypesShowHidePresenter >> findSelectedItems [

	| controllers |
	controllers := diagramController controllers.
	^ tree roots anyOne withAllChildren select: [ :typeNode |
		  controllers anySatisfy: [ :controller | typeNode matchesType: controller viewModel modelType ] ]
]

{ #category : 'accessing' }
OPTypesShowHidePresenter >> getRootNode [

	^ OPModelObjectTypeRootNode withChildrenFromTypes: (self allElements collect: [ :each | viewModelRegistry modelTypeFor: each ])
]

{ #category : 'hooks' }
OPTypesShowHidePresenter >> initialRoots [

	^ { (OPModelObjectTypeRootNode withChildrenFromTypes:
		   (self allElements collect: [ :each | viewModelRegistry modelTypeFor: each ])) }
]

{ #category : 'hooks' }
OPTypesShowHidePresenter >> nameFor: aNode [
	^ aNode name
]

{ #category : 'hooks' }
OPTypesShowHidePresenter >> selected: aSelectedTypeNode [

	| elementsToShow executor |
	elementsToShow := self elementsWithTypesInNode: aSelectedTypeNode.
	executor := OPDiagramExplorer on: diagramController.
	executor showElements: elementsToShow.
	^ elementsToShow
]

{ #category : 'hooks' }
OPTypesShowHidePresenter >> unselected: aRemovedTypeNode [

	| elementsToHide executor |
	elementsToHide := self elementsWithTypesInNode: aRemovedTypeNode.
	executor := OPDiagramExplorer on: diagramController.
	executor hideElements: elementsToHide.
	^ elementsToHide
]
