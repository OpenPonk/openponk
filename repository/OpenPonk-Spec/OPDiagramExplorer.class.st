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

{ #category : #actions }
OPDiagramExplorer >> applyLayoutCenter: aCentralFigure neighbors: neighbors [
	"NSPRadialLayoutToggleCommand new
		figure: aCentralFigure;
		figures: neighbors;
		distance: 800;
		duration: 0.01 seconds;
		execute;
		hideGuides"
]

{ #category : #accessing }
OPDiagramExplorer >> dependentFor: aModelObject [
	^ adapters dependentFor: aModelObject in: diagramController model
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
	diagramController view signalUpdate
]

{ #category : #accessing }
OPDiagramExplorer >> incomingSourcesOf: aDataElement [
	^ self diagramController model dataElements
		select:
			[ :each | each fields anySatisfy: [ :f | f isLinkField and: [ f targetElement = aDataElement ] ] ]
]

{ #category : #initialization }
OPDiagramExplorer >> initialize [
	super initialize.
	adapters := OPNavigatorAdapters default
]

{ #category : #accessing }
OPDiagramExplorer >> outgoingTargetsOf: aDataElement [
	^ ((aDataElement fields
		select: [ :each | each isLinkField and: [ each linkField isLocalLink ] ])
		collect: #targetElement) \ {aDataElement}
]

{ #category : #initialization }
OPDiagramExplorer >> setDiagramController: aDiagramController [
	diagramController := aDiagramController
]

{ #category : #actions }
OPDiagramExplorer >> showAllElements [
	diagramController rebuild
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
		collect: [ :each | diagramController controllerForModel: each ifNone: [ nil ] ]
		thenSelect: [ :each | each isNotNil ].
	ctrls := (aCollectionOfModelObjects
		sorted:
			[ :a :b | adapters dependsTypeOf: b on: a in: diagramController model ])
		collect: [ :each | diagramController showWithoutDependentInDiagramModel: each ].
	diagramController enableRefresh.
	ctrls \ existingCtrls do: #refreshFigure
]

{ #category : #actions }
OPDiagramExplorer >> showElements: dataElements of: aCentralElement [
	| links ctrls1 ctrls2 existingCtrls |
	self diagramController deselectAll.
	links := diagramController
		selectUnifiedRelationshipsInCollection: dataElements , {aCentralElement}.
	diagramController disableRefresh.
	existingCtrls := OrderedCollection new.
	dataElements , (links collect: #linkField)
		do:
			[ :each | diagramController controllerForModel: each ifFound: [ :ctrl | existingCtrls add: ctrl ] ].
	ctrls1 := dataElements collect: [ :each | diagramController showWithoutDependentInDiagramModel: each ].
	ctrls2 := links collect: [ :each | diagramController showWithoutDependentInDiagramModel: each linkField ].
	diagramController enableRefresh.
	(ctrls1 , ctrls2) \ existingCtrls do: #refreshFigure.
	self
		applyLayoutCenter: (diagramController controllerForModel: aCentralElement) figure
		neighbors: (ctrls1 collect: #figure)
]

{ #category : #actions }
OPDiagramExplorer >> showLinks: links [
	| ctrls |
	links ifEmpty: [ ^ self ].
	self diagramController deselectAll.
	ctrls := links collect: [ :each | diagramController showWithoutDependentInDiagramModel: each ].
	diagramController enableRefresh.
	ctrls do: #refreshFigure
]

{ #category : #actions }
OPDiagramExplorer >> showOutgoingNeighborsOf: aDataElement [
	self showElements: (self outgoingTargetsOf: aDataElement) of: aDataElement
]

{ #category : #actions }
OPDiagramExplorer >> showTargetOf: aLinkField [
	self
		showElements:
			{aLinkField targetElement.
			aLinkField dataElement}
		of: aLinkField dataElement
]
