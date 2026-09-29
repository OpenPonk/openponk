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

{ #category : 'hooks' }
OPCherryPickShowHidePresenter >> childrenFor: aViewModel [

	^ (aViewModel dependentElements
		   select: [ :each | diagramController hasSupportForModel: each ]
		   thenCollect: [ :each | viewModelRegistry viewModelFor: each ]) asSortedCollection: [ :a :b |
		  a modelDisplayString < b modelDisplayString ]
]

{ #category : 'updating' }
OPCherryPickShowHidePresenter >> findSelectedItems [

	^ (diagramController controllers collect: [ :each | each viewModel ]) copyWith: diagramController viewModel
]

{ #category : 'hooks' }
OPCherryPickShowHidePresenter >> iconFor: aViewModel [

	^ aViewModel icon
]

{ #category : 'hooks' }
OPCherryPickShowHidePresenter >> initialRoots [

	^ { diagramController viewModel }
]

{ #category : 'hooks' }
OPCherryPickShowHidePresenter >> nameFor: aViewModel [

	^ aViewModel modelDisplayString
]

{ #category : 'hooks' }
OPCherryPickShowHidePresenter >> selected: anAddedViewModel [

	| executor |
	executor := OPDiagramExplorer on: diagramController.
	executor showElement: anAddedViewModel model.
	^ { anAddedViewModel }
]

{ #category : 'hooks' }
OPCherryPickShowHidePresenter >> unselected: aRemovedViewModel [

	| executor |
	executor := OPDiagramExplorer on: diagramController.
	executor hideElement: aRemovedViewModel model.
	^ { aRemovedViewModel }
]
