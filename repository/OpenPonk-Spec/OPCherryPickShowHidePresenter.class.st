Class {
	#name : #OPCherryPickShowHidePresenter,
	#superclass : #OPShowHideTabContentPresenter,
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #accessing }
OPCherryPickShowHidePresenter >> childrenFor: aModelObject [
	^ adapters
		sort: (adapters dependentFor: aModelObject in: diagramController model)
]

{ #category : #defaults }
OPCherryPickShowHidePresenter >> findSelectedItems [
	^ diagramController allVisibleShowableElements
		ifNotEmpty: [ :newElements | newElements copyWith: diagramController model ]
]

{ #category : #defaults }
OPCherryPickShowHidePresenter >> iconFor: aModelObject [
	^ adapters iconFor: aModelObject
]

{ #category : #'as yet unclassified' }
OPCherryPickShowHidePresenter >> initialRoots [
	^ {diagramController model}
]

{ #category : #general }
OPCherryPickShowHidePresenter >> nameFor: anObject [
	^ adapters displayFor: anObject
]

{ #category : #accessing }
OPCherryPickShowHidePresenter >> selected: added [
	| executor |
	executor := OPDiagramExplorer on: diagramController.
	executor showElement: added.
	^ {added}
]

{ #category : #accessing }
OPCherryPickShowHidePresenter >> unselected: removed [
	| executor |
	executor := OPDiagramExplorer on: diagramController.
	executor hideElement: removed.
	^ {removed}
]
