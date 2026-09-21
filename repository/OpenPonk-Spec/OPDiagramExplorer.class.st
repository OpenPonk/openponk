"
Provides an interface to navigate, discover, and toggle the visibility of diagram elements. 
Coordinates with the OPViewModelRegistry and OPDiagramController to hide or show dependencies and connected elements.
"
Class {
	#name : 'OPDiagramExplorer',
	#superclass : 'Object',
	#instVars : [
		'diagramController',
		'viewModelRegistry'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'instance creation' }
OPDiagramExplorer class >> on: aDiagramController [
	^ self new
		setDiagramController: aDiagramController;
		yourself
]

{ #category : 'accessing' }
OPDiagramExplorer >> dependentFor: aModelObject [

	^ self viewModelRegistry dependentFor: aModelObject
]

{ #category : 'accessing' }
OPDiagramExplorer >> diagramController [
	^ diagramController
]

{ #category : 'actions' }
OPDiagramExplorer >> hideAllElements [
	self hideElements: (diagramController controllers collect: [ :each | each model ])
]

{ #category : 'actions' }
OPDiagramExplorer >> hideDependentFor: aDataElement [
	self hideElements: (self dependentFor: aDataElement)
]

{ #category : 'actions' }
OPDiagramExplorer >> hideElement: element [
	element = diagramController model
		ifTrue: [ ^ self hideAllElements ].
	self hideElements: { element }
]

{ #category : 'actions' }
OPDiagramExplorer >> hideElements: aCollectionOfModelObjects [
	| toHide transactionLabel |
	aCollectionOfModelObjects ifEmpty: [ ^ self ].
	toHide := aCollectionOfModelObjects select: [ :eachModelObject |
		diagramController hasControllerForModel: eachModelObject ].
	toHide ifEmpty: [ ^ self ].

	transactionLabel := toHide size > 1 ifTrue: [ 'Hide Elements' ] ifFalse: [ 'Hide Element' ].
	self undoManager inTransactionLabeled: transactionLabel do: [
		toHide do: [ :eachModelObject |
			(diagramController hasControllerForModel: eachModelObject) ifTrue: [
				self undoManager execute: (OPHideDiagramElementCommand
					model: eachModelObject
					diagramController: diagramController) ] ] ].

	diagramController canvas signalUpdate
]

{ #category : 'initialization' }
OPDiagramExplorer >> setDiagramController: aDiagramController [

	diagramController := aDiagramController
]

{ #category : 'actions' }
OPDiagramExplorer >> showAllElements [
	self showElements: (diagramController allModelElementsWithPossibleController copyWithout: diagramController model)
]

{ #category : 'actions' }
OPDiagramExplorer >> showDependentFor: aModelObject [

	self showElements: (self dependentFor: aModelObject)
]

{ #category : 'actions' }
OPDiagramExplorer >> showElement: aModelObject [
	aModelObject = diagramController model
		ifTrue: [ ^ self showAllElements ].
	self showElements: { aModelObject }
]

{ #category : 'showing/hiding' }
OPDiagramExplorer >> showElements: aCollectionOfModelObjects [
	| allModels queue toShow sortedElements |
	aCollectionOfModelObjects ifEmpty: [ ^ self ].

	allModels := Set new.
	queue := OrderedCollection withAll: aCollectionOfModelObjects.
	[ queue isNotEmpty ] whileTrue: [
		| currentModel |
		currentModel := queue removeFirst.
		(allModels includes: currentModel) ifFalse: [
			allModels add: currentModel.
			(self viewModelRegistry hasViewModelFor: currentModel) ifTrue: [
				| currentViewModel |
				currentViewModel := self viewModelRegistry viewModelFor: currentModel.
				currentViewModel dependingOnElements do: [ :eachDependency |
					eachDependency ifNotNil: [
						(allModels includes: eachDependency) ifFalse: [
							queue add: eachDependency ] ] ] ] ] ].

	toShow := allModels reject: [ :eachModelObject |
		eachModelObject = diagramController model or: [
			diagramController hasControllerForModel: eachModelObject ] ].
	toShow ifEmpty: [
		aCollectionOfModelObjects do: [ :eachModelObject |
			diagramController
				controllerForModel: eachModelObject
				ifFound: [ :elementController | elementController modelChanged ] ].
		^ self ].

	sortedElements := toShow sorted: [ :firstModel :secondModel |
		(self viewModelRegistry viewModelFor: firstModel) creationPriority <= (self viewModelRegistry viewModelFor: secondModel) creationPriority ].

	diagramController disableRefresh.
	[
		| transactionLabel |
		transactionLabel := sortedElements size > 1 ifTrue: [ 'Show Elements' ] ifFalse: [ 'Show Element' ].
		self undoManager inTransactionLabeled: transactionLabel do: [
			sortedElements do: [ :eachModelObject |
				self undoManager execute: (OPShowDiagramElementCommand
					model: eachModelObject
					diagramController: diagramController) ] ]
	] ensure: [
		diagramController enableRefresh ]
]

{ #category : 'accessing' }
OPDiagramExplorer >> undoManager [
	^ diagramController undoManager
]

{ #category : 'accessing' }
OPDiagramExplorer >> viewModelRegistry [

	^ viewModelRegistry ifNil: [
		  viewModelRegistry := diagramController viewModel registry ]
]
