"
I am a browser/dialog where one can specify what elements are currently visible in the diagram.
"
Class {
	#name : #OPShowHideElementsBrowser,
	#superclass : #Object,
	#instVars : [
		'diagramController'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #browsers }
OPShowHideElementsBrowser >> buildBrowser [
	| browser |
	browser := GLMTabulator new.
	browser row: #picker.
	browser initialExtent: 600 @ 600.
	browser transmit
		to: #picker;
		andShow: [ :a | self pickerIn: a ].
	^ browser
]

{ #category : #accessing }
OPShowHideElementsBrowser >> childrenFor: anElement [
	(anElement isKindOf: NSMComponent)
		ifTrue:
			[ ^ anElement dataElements asArray sorted: [ :a :b | a name < b name ] ].
	(anElement isKindOf: NSMDataElement)
		ifTrue: [ ^ (anElement fields asArray sorted: [ :a :b | a name < b name ])
				select: [ :each | each isLinkField and: [ each linkField isLocalLink ] ] ].
	^ {}
]

{ #category : #presentations }
OPShowHideElementsBrowser >> dataElementTypes: aComposite [
	^ aComposite morph
		title: 'Data Element Types';
		morph: [ :morphPresentation | 
			| treeModel treeMorph allTypes |
			treeModel := MorphTreeModel new.
			allTypes := NSMDataElement dataElementTypes.
			treeModel
				beCheckList;
				rootItems: allTypes;
				onSelectionChangeSend: #filterSelectionChanged: to: self;
				wrapBlockOrSelector: [ :each | 
					Smalltalk ui theme
						newRowIn: World
						for:
							{BorderedMorph new
								extent: 50 @ 20;
								color: (NSPColor colors at: each).
							each asString asMorph} ];
				autoMultiSelection: true.
			treeMorph := treeModel defaultTreeMorph
				buildContents;
				selectedItems: self dataElementTypesSelection;
				vResizing: #spaceFill;
				yourself ]
]

{ #category : #retrieving }
OPShowHideElementsBrowser >> dataElementTypesSelection [
	| allTypes elements visible hidden |
	allTypes := NSMDataElement dataElementTypes.
	elements := diagramController model dataElements
		groupedBy: [ :each | diagramController isVisibleInDiagram: each ].
	visible := elements at: true ifAbsent: [ #() ].
	hidden := elements at: false ifAbsent: [ #() ].
	^ allTypes
		select: [ :typeName | hidden noneSatisfy: [ :each | each type name = typeName ] ]
]

{ #category : #actions }
OPShowHideElementsBrowser >> filterSelectionChanged: anEvent [
	| newVisibleTypes show hide executor shownElements shownBefore hiddenBefore allTypes |
	newVisibleTypes := anEvent selection selectedItems.
	shownBefore := self dataElementTypesSelection.
	allTypes := NSMDataElement dataElementTypes.
	show := newVisibleTypes \ shownBefore.
	hiddenBefore := allTypes \ shownBefore.
	hide := allTypes \ newVisibleTypes \ hiddenBefore.
	show := show copyReplaceAll: {'None'} with: {nil}.
	hide := hide copyReplaceAll: {'None'} with: {nil}.
	executor := NSPShowHideFacade on: diagramController.
	executor
		hide: (diagramController model dataElements select: [ :each | hide includes: each type name ]).
	shownElements := diagramController model dataElements
		select: [ :each | show includes: each type name ].
	executor showDisconnected: shownElements.
	executor connectToVisible: shownElements
]

{ #category : #accessing }
OPShowHideElementsBrowser >> iconFor: anElement [
	(anElement isKindOf: NSMDataElement)
		ifTrue: [ ^ NSPIcons dataElementIcon ].
	(anElement isKindOf: NSMComponent)
		ifTrue: [ ^ NSPIcons componentIcon ].
	(anElement isKindOf: NSMField)
		ifTrue: [ ^ NSPIcons relationshipIcon ].
	^ nil
]

{ #category : #accessing }
OPShowHideElementsBrowser >> initialPick [
	^ diagramController hideableElements asSet
		select: [ :each | diagramController isVisibleInDiagram: each ]
]

{ #category : #accessing }
OPShowHideElementsBrowser >> nameFor: anElement [
	^ anElement model name
]

{ #category : #opening }
OPShowHideElementsBrowser >> openOn: aDiagramController [
	self startOn: aDiagramController.
	^ self buildBrowser
		title:
			'Show/Hide Elements in Diagram ' , diagramController model name , ' ('
				, diagramController diagram name , ')';
		openOn: {diagramController}
]

{ #category : #actions }
OPShowHideElementsBrowser >> pickChanged: aSet [
	| all visible added removed hidden executor addedLinks actions removedLinks linksPick |
	all := component dataElements asArray.
	visible := all
		select: [ :each | diagramController isVisibleInDiagram: each ].
	hidden := all \ visible.
	removed := visible \ aSet.
	added := aSet intersection: hidden.
	executor := NSPERDiagramExplorer on: diagramController.
	executor hideElements: removed.
	executor showElements: added.
	linksPick := aSet select: [ :each | each isKindOf: NSMField ].
	actions := (visible flatCollect: #fields)
		select: [ :each | each isLinkField and: [ each linkField isLocalLink ] ].
	addedLinks := linksPick \ all
		reject: [ :each | 
			(removed includes: each dataElement)
				| (removed includes: each targetElement) ].
	removedLinks := actions \ linksPick.
	executor showLinkFields: addedLinks.
	executor hideElements: (removedLinks collect: #linkField)
]

{ #category : #presentations }
OPShowHideElementsBrowser >> pickerIn: aComposite [
	^ (aComposite custom: OPGLMCherryPickTreePresentation new)
		title: 'Select Manually';
		allExpanded;
		children: [ :item | self childrenFor: item ];
		format: [ :item | self nameFor: item ];
		icon: [ :item | self iconFor: item ];
		selectionCascade: [ :item | self selectionCascadeFor: item ];
		onChangeOfCherryPick: [ :it | self pickChanged: it cherryPick ];
		initialPick: self initialPick;
		enableFilter;
		allowDeselection;
		yourself
]

{ #category : #accessing }
OPShowHideElementsBrowser >> selectionCascadeFor: anElement [
	(anElement isKindOf: NSMDataElement)
		ifTrue: [ ^ self selectionCascadeForElement: anElement ].
	(anElement isKindOf: NSMComponent)
		ifTrue: [ ^ anElement dataElements
				,
					((anElement dataElements flatCollect: #fields)
						select: #isLocalLinkField) ].
	^ #()
]

{ #category : #accessing }
OPShowHideElementsBrowser >> selectionCascadeForElement: aDataElement [
	^ (aDataElement fields select: #isLocalLinkField)
		select: [ :each | 
			diagramController
				isVisibleInDiagram:
					({each dataElement.
					each targetElement} copyWithout: aDataElement) first ]
]

{ #category : #opening }
OPShowHideElementsBrowser >> startOn: aDiagramController [
	diagramController := aDiagramController
]
