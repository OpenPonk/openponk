"
Concrete Spec presenter used within OPShowHidePresenter. 
Provides a tree view that allows users to manually ""cherry-pick"" specific individual model elements to show or hide on the diagram canvas.
"
Class {
	#name : 'OPCherryPickShowHidePresenter',
	#superclass : 'OPShowHideTabContentPresenter',
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'accessing' }
OPCherryPickShowHidePresenter >> childrenFor: aViewModel [

	| items |
	items := aViewModel dependentElements collect: [ :each |
		         each registry viewModelFor: each ].
	^ items sortedAs: #modelDisplayString
]

{ #category : 'defaults' }
OPCherryPickShowHidePresenter >> findSelectedItems [
	^ diagramController allModelElementsWithController
		ifNotEmpty: [ :newElements | newElements copyWith: diagramController model ]
]

{ #category : 'defaults' }
OPCherryPickShowHidePresenter >> iconFor: aViewModel [

	^ aViewModel icon
]

{ #category : 'accessing' }
OPCherryPickShowHidePresenter >> initialRoots [

	^ { diagramController viewModel }
]

{ #category : 'general' }
OPCherryPickShowHidePresenter >> nameFor: aViewModel [

	^ aViewModel modelDisplayString
]

{ #category : 'accessing' }
OPCherryPickShowHidePresenter >> selected: anAddedViewModel [

	| executor |
	executor := OPDiagramExplorer on: diagramController.
	executor showElement: anAddedViewModel model.
	^ { anAddedViewModel }
]

{ #category : 'accessing' }
OPCherryPickShowHidePresenter >> unselected: aRemovedViewModel [

	| executor |
	executor := OPDiagramExplorer on: diagramController.
	executor hideElement: aRemovedViewModel model.
	^ { aRemovedViewModel }
]
