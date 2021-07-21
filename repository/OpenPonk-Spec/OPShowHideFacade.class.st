Class {
	#name : #OPShowHideFacade,
	#superclass : #Object,
	#instVars : [
		'diagramController',
		'executor'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #'instance creation' }
OPShowHideFacade class >> on: aDiagramController [
	^ self new
		setDiagramController: aDiagramController;
		yourself
]

{ #category : #showing }
OPShowHideFacade >> hide: aCollection [
	executor hideElements: aCollection
]

{ #category : #normalizing }
OPShowHideFacade >> hideAll [
	executor hideAllElements
]

{ #category : #accessing }
OPShowHideFacade >> layout [
	^ diagramController layouter
]

{ #category : #initialization }
OPShowHideFacade >> setDiagramController: aDiagramController [
	diagramController := aDiagramController.
	executor := OPDiagramExplorer on: aDiagramController
]

{ #category : #normalizing }
OPShowHideFacade >> showAll [
	executor showAllElements
]

{ #category : #showing }
OPShowHideFacade >> showElements: aCollection [
	executor showElements: aCollection
]
