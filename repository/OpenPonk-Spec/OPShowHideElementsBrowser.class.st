"
I am a browser/dialog where one can specify what elements are currently visible in the diagram.
"
Class {
	#name : #OPShowHideElementsBrowser,
	#superclass : #Object,
	#instVars : [
		'diagramController',
		'adapters',
		'treeModel',
		'selectionMutex'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #accessing }
OPShowHideElementsBrowser >> allElements [
	^ diagramController allShowableElements
]

{ #category : #browsers }
OPShowHideElementsBrowser >> buildBrowser [
	| browser |
	browser := GLMTabulator new.
	browser row: #picker.
	browser initialExtent: 600 @ 600.
	browser transmit
		to: #picker;
		andShow: [ :a | 
			self
				pickerIn: a;
				elementTypes: a ].
	^ browser
]

{ #category : #accessing }
OPShowHideElementsBrowser >> childrenFor: aModelObject [
	^ adapters dependentFor: aModelObject in: diagramController model
]

{ #category : #'as yet unclassified' }
OPShowHideElementsBrowser >> elementTypes: aComposite [
	^ aComposite morph
		title: 'Element Types';
		morph: [ :morphPresentation | 
			| treeMorph allTypes colors allTypesWithNames |
			treeModel := MorphTreeModel new.
			allTypesWithNames := self possibleElementTypesWithNames.
			allTypes := (allTypesWithNames associations
				sorted: [ :a :b | a value < b value ]) collect: #key.
			colors := Color wheel: allTypes size.
			colors := (allTypes
				collectWithIndex: [ :type :index | type -> (colors at: index) ])
				asDictionary.
			treeModel
				beCheckList;
				rootItems: allTypes;
				wrapBlockOrSelector: [ :each | 
					Smalltalk ui theme
						newRowIn: World
						for:
							{(BorderedMorph new
								extent: 50 @ 20;
								color: (colors at: each)).
							(allTypesWithNames at: each) asMorph} ];
				autoMultiSelection: true.
			treeMorph := treeModel defaultTreeMorph
				buildContents;
				selectedItems: self elementTypesSelection;
				vResizing: #spaceFill;
				yourself.
			treeModel onSelectionChangeSend: #typesChangedBy: to: self.
			treeMorph ]
]

{ #category : #'as yet unclassified' }
OPShowHideElementsBrowser >> elementTypesSelection [
	| allTypes elements visible hidden |
	allTypes := self possibleElementTypes.
	elements := self allElements
		groupedBy: [ :each | diagramController isVisibleInDiagram: each ].
	visible := elements at: true ifAbsent: [ #() ].
	hidden := elements at: false ifAbsent: [ #() ].
	^ allTypes
		select: [ :type | visible anySatisfy: [ :each | each class = type ] ]
]

{ #category : #accessing }
OPShowHideElementsBrowser >> iconFor: aModelObject [
	^ adapters iconFor: aModelObject
]

{ #category : #accessing }
OPShowHideElementsBrowser >> initialPick [
	^ diagramController allVisibleShowableElements
		, {diagramController model}
]

{ #category : #initialization }
OPShowHideElementsBrowser >> initialize [
	super initialize.
	adapters := OPNavigatorAdapters default.
	selectionMutex := Semaphore forMutualExclusion
]

{ #category : #accessing }
OPShowHideElementsBrowser >> nameFor: anObject [
	^ adapters displayFor: anObject
]

{ #category : #opening }
OPShowHideElementsBrowser >> openOn: aDiagramController [
	self startOn: aDiagramController.
	^ self buildBrowser
		title:
			'Show/Hide Elements in ' , diagramController model name , ' ('
				, diagramController diagram name , ')';
		openOn: {diagramController model}
]

{ #category : #actions }
OPShowHideElementsBrowser >> pickChanged: picked [
	| all visible added removed hidden executor |
	all := diagramController allShowableElements asArray.
	visible := all
		select: [ :each | diagramController isVisibleInDiagram: each ].
	hidden := all \ visible.
	removed := visible \ picked.
	added := picked intersection: hidden.
	executor := OPDiagramExplorer on: diagramController.
	executor hideElements: removed.
	executor showElements: added
]

{ #category : #presentations }
OPShowHideElementsBrowser >> pickerIn: aComposite [
	^ (aComposite custom: OPGLMCherryPickTreePresentation new)
		title: 'Select Manually';
		allExpanded;
		children: [ :item | self childrenFor: item ];
		format: [ :item | self nameFor: item ];
		icon: [ :item | self iconFor: item ];
		onChangeOfCherryPick: [ :it | self pickChanged: it cherryPick ];
		initialPick: self initialPick;
		enableFilter;
		allowDeselection;
		yourself
]

{ #category : #accessing }
OPShowHideElementsBrowser >> possibleElementTypes [
	^ self possibleElementTypesWithNames keys
]

{ #category : #accessing }
OPShowHideElementsBrowser >> possibleElementTypesWithNames [
	^ (diagramController elementsToShowInside
		collect: [ :each | each class -> (diagramController nameOfTypeForModel: each) ])
		asSet asDictionary
]

{ #category : #opening }
OPShowHideElementsBrowser >> startOn: aDiagramController [
	diagramController := aDiagramController
]

{ #category : #'as yet unclassified' }
OPShowHideElementsBrowser >> typesChangedBy: anEvent [
	| executor allTypes pickedTypes visibleTypes typesToShow hiddenTypes typesToHide toShow toHide |
	selectionMutex
		critical: [ pickedTypes := anEvent selection selectedItems.
			visibleTypes := self elementTypesSelection.
			allTypes := self possibleElementTypes.
			typesToShow := pickedTypes \ visibleTypes.
			hiddenTypes := allTypes \ visibleTypes.
			typesToHide := allTypes \ pickedTypes \ hiddenTypes.
			toShow := self allElements
				select: [ :each | typesToShow includes: each class ].
			toHide := self allElements
				select: [ :each | typesToHide includes: each class ].
			executor := OPDiagramExplorer on: diagramController.
			executor hideElements: toHide.
			executor showElements: toShow.
			treeModel selectItems: self elementTypesSelection ]
		ifLocked: [ "do nothing" ]
]
