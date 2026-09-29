"
Simplified facade providing high-level commands to systematically show or hide collections of diagram elements and trigger automated layout updates.
"
Class {
	#name : 'OPShowHideFacade',
	#superclass : 'Object',
	#instVars : [
		'diagramController',
		'executor'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'instance creation' }
OPShowHideFacade class >> on: aDiagramController [
	^ self new
		setDiagramController: aDiagramController;
		yourself
]

{ #category : 'showing' }
OPShowHideFacade >> hide: aCollection [
	executor hideElements: aCollection
]

{ #category : 'normalizing' }
OPShowHideFacade >> hideAll [
	executor hideAllElements
]

{ #category : 'accessing' }
OPShowHideFacade >> layout [
	^ diagramController layouter
]

{ #category : 'initialization' }
OPShowHideFacade >> setDiagramController: aDiagramController [
	diagramController := aDiagramController.
	executor := OPDiagramExplorer on: aDiagramController
]

{ #category : 'normalizing' }
OPShowHideFacade >> showAll [
	executor showAllElements
]

{ #category : 'showing' }
OPShowHideFacade >> showElements: aCollection [
	executor showElements: aCollection
]
