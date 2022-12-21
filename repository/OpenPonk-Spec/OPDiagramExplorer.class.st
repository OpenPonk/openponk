Class {
	#name : #OPDiagramExplorer,
	#superclass : #Object,
	#instVars : [
		'diagramController',
		'adapters'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #'instance creation' }
OPDiagramExplorer class >> on: aDiagramController [
	^ self new
		setDiagramController: aDiagramController;
		yourself
]

{ #category : #accessing }
OPDiagramExplorer >> adapters [

	^ adapters ifNil: [ 
		  adapters := diagramController editor
			              ifNil: [ OPNavigatorAdapters new ]
			              ifNotNil: [ 
				              diagramController editor workbench projectController
					              navigatorAdapters ] ]
]

{ #category : #accessing }
OPDiagramExplorer >> dependentFor: aModelObject [

	^ self adapters dependentFor: aModelObject in: diagramController model
]

{ #category : #accessing }
OPDiagramExplorer >> diagramController [
	^ diagramController
]

{ #category : #actions }
OPDiagramExplorer >> hideAllElements [
	diagramController hideAllElements
]

{ #category : #actions }
OPDiagramExplorer >> hideDependentFor: aDataElement [
	self hideElements: (self dependentFor: aDataElement)
]

{ #category : #actions }
OPDiagramExplorer >> hideElement: element [
	diagramController deselectAll.
	element = diagramController model
		ifTrue: [ diagramController hideAllElements ]
		ifFalse: [ diagramController hideModelFromDiagram: element ].
	diagramController view signalUpdate
]

{ #category : #actions }
OPDiagramExplorer >> hideElements: elements [
	diagramController deselectAll.
	elements
		do: [ :each | diagramController hideModelFromDiagram: each ].
	diagramController canvas signalUpdate
]

{ #category : #initialization }
OPDiagramExplorer >> setDiagramController: aDiagramController [

	diagramController := aDiagramController
]

{ #category : #actions }
OPDiagramExplorer >> showAllElements [
	diagramController showInDiagram: diagramController model
]

{ #category : #actions }
OPDiagramExplorer >> showDependentFor: aModelObject [
	self showElements: (self dependentFor: aModelObject)
]

{ #category : #actions }
OPDiagramExplorer >> showElement: aModelObject [
	| existingCtrl ctrl |
	self diagramController deselectAll.
	aModelObject = diagramController model
		ifTrue: [ ^ diagramController showAllElements ].
	diagramController disableRefresh.
	existingCtrl := diagramController
		controllerForModel: aModelObject
		ifNone: [ nil ].
	ctrl := diagramController
		showWithoutDependentInDiagramModel: aModelObject.
	diagramController enableRefresh.
	existingCtrl ifNil: [ ^ self ].
	ctrl refreshFigure
]

{ #category : #actions }
OPDiagramExplorer >> showElements: aCollectionOfModelObjects [

	| ctrls existingCtrls |
	aCollectionOfModelObjects ifEmpty: [ ^ self ].
	self diagramController deselectAll.
	diagramController disableRefresh.
	existingCtrls := aCollectionOfModelObjects asArray
		                 collect: [ :each | 
		                 diagramController
			                 controllerForModel: each
			                 ifNone: [ nil ] ]
		                 thenSelect: [ :each | each isNotNil ].
	ctrls := (aCollectionOfModelObjects sorted: [ :a :b | 
		          self adapters
			          dependsTypeOf: b
			          on: a
			          in: diagramController model ]) collect: [ :each | 
		         diagramController showWithoutDependentInDiagramModel: each ].
	diagramController enableRefresh
]
