Class {
	#name : #OPShowHidePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'diagramController',
		'cherryPicker',
		'typesPicker',
		'notebook'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #specs }
OPShowHidePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #notebook;
		yourself
]

{ #category : #initialization }
OPShowHidePresenter >> cherryPickPage [
	^ SpNotebookPage
		title: 'By dependency'
		provider: [ OPCherryPickShowHidePresenter owner: self on: diagramController ]
]

{ #category : #initialization }
OPShowHidePresenter >> connectPresenters [
	super connectPresenters.
	notebook
		whenSelectedPageChangedDo: [ :selectedPage | self refreshPage: selectedPage ]
]

{ #category : #initialization }
OPShowHidePresenter >> initializePresenters [
	notebook := self newNotebook.
	notebook
		addPage: self cherryPickPage;
		addPage: self typesPage
]

{ #category : #initialization }
OPShowHidePresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title:
			'Show / Hide Elements in ' , diagramController diagram name
				, ' - OpenPonk'.
	aWindowPresenter window announcer
		when: WindowActivated
		do: [ self refreshCurrentPage ]
]

{ #category : #initialization }
OPShowHidePresenter >> refreshCurrentPage [
	notebook selectedPage
		ifNotNil: [ :selectedPage | self refreshPage: selectedPage ]
]

{ #category : #initialization }
OPShowHidePresenter >> refreshPage: aPage [
	aPage activePresenter
		ifNotNil: [ :presenter | presenter updateSelectedItems ]
]

{ #category : #'accessing model' }
OPShowHidePresenter >> setModelBeforeInitialization: aDiagramController [
	diagramController := aDiagramController
]

{ #category : #initialization }
OPShowHidePresenter >> typesPage [
	^ SpNotebookPage
		title: 'By type'
		provider: [ OPTypesShowHidePresenter owner: self on: diagramController ]
]
