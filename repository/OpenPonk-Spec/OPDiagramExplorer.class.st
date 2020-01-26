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

{ #category : #actions }
OPDiagramExplorer >> connectToNeighborsOf: aDataElement [
	self showElements: (self visibleNeighborsOf: aDataElement) of: aDataElement
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
OPDiagramExplorer >> hideElements: dataElements [
	diagramController deselectAll.
	dataElements
		do: [ :each | diagramController hideModelFromDiagram: each ].
	diagramController view signalUpdate
]

{ #category : #actions }
OPDiagramExplorer >> hideNeighborsOf: aDataElement [
	self hideElements: (self neighborsOf: aDataElement)
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
	adapters := OPNavigatorAdapters new
]

{ #category : #accessing }
OPDiagramExplorer >> neighborsOf: aModelObject [
	^ adapters childrenFor: aModelObject
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
OPDiagramExplorer >> showElements: aCollectionOfModelObjects [
	| ctrls existingCtrls |
	aCollectionOfModelObjects ifEmpty: [ ^ self ].
	self diagramController deselectAll.
	diagramController disableRefresh.
	existingCtrls := aCollectionOfModelObjects
		collect: [ :each | diagramController controllerForModel: each ifNone: [ nil ] ]
		thenSelect: [ :each | each isNotNil ].
	ctrls := aCollectionOfModelObjects
		collect: [ :each | diagramController showModelInDiagram: each ].
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
	ctrls1 := dataElements collect: [ :each | diagramController showModelInDiagram: each ].
	ctrls2 := links collect: [ :each | diagramController showModelInDiagram: each linkField ].
	diagramController enableRefresh.
	(ctrls1 , ctrls2) \ existingCtrls do: #refreshFigure.
	self
		applyLayoutCenter: (diagramController controllerForModel: aCentralElement) figure
		neighbors: (ctrls1 collect: #figure)
]

{ #category : #actions }
OPDiagramExplorer >> showLinkFields: aCollection [
	| newElements links ctrls |
	aCollection ifEmpty: [ ^ self ].
	self diagramController deselectAll.
	newElements := OrderedCollection new.
	aCollection
		do: [ :each | 
			(diagramController isVisibleInDiagram: each dataElement)
				ifFalse: [ newElements add: each dataElement ].
			(diagramController isVisibleInDiagram: each targetElement)
				ifFalse: [ newElements add: each targetElement ] ].
	self showElements: newElements.
	links := aCollection
		flatCollect: [ :each | 
			diagramController
				selectUnifiedRelationshipsInCollection:
					{each dataElement.
					each targetElement} ].
	diagramController
		refreshDisabledDuring: [ ctrls := links
				collect: [ :each | 
					diagramController showModelInDiagram: each.
					each opposite ifNotNil: [ :op | diagramController showModelInDiagram: op ].
					diagramController showModelInDiagram: each linkField ] ]
		afterDo: [ ctrls do: #refreshFigure ]
]

{ #category : #actions }
OPDiagramExplorer >> showLinks: links [
	| ctrls |
	links ifEmpty: [ ^ self ].
	self diagramController deselectAll.
	ctrls := links collect: [ :each | diagramController showModelInDiagram: each ].
	diagramController enableRefresh.
	ctrls do: #refreshFigure
]

{ #category : #actions }
OPDiagramExplorer >> showNeighborsOf: aDataElement [
	self showElements: (self neighborsOf: aDataElement)
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

{ #category : #accessing }
OPDiagramExplorer >> visibleNeighborsOf: aDataElement [
	^ (self neighborsOf: aDataElement)
		select: [ :each | diagramController isVisibleInDiagram: each ]
]
