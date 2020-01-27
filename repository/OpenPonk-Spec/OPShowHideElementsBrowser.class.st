"
I am a browser/dialog where one can specify what elements are currently visible in the diagram.
"
Class {
	#name : #OPShowHideElementsBrowser,
	#superclass : #Object,
	#instVars : [
		'diagramController',
		'adapters'
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
OPShowHideElementsBrowser >> childrenFor: aModelObject [
	^ adapters childrenFor: aModelObject
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
	adapters := OPNavigatorAdapters new
]

{ #category : #accessing }
OPShowHideElementsBrowser >> nameFor: aModel [
	^ adapters adaptersFor: aModel detect: #displayFor:
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
OPShowHideElementsBrowser >> pickChanged: aSet [
	| all visible added removed hidden executor |
	all := diagramController allShowableElements asArray.
	visible := all
		select: [ :each | diagramController isVisibleInDiagram: each ].
	hidden := all \ visible.
	removed := visible \ aSet.
	added := aSet intersection: hidden.
	executor := OPDiagramExplorer on: diagramController.
	executor hideElements: removed.
	executor showElements: added
	"
	linksPick := aSet select: [ :each | each isKindOf: NSMField ].
	actions := (visible flatCollect: #fields)
		select: [ :each | each isLinkField and: [ each linkField isLocalLink ] ].
	addedLinks := linksPick \ all
		reject: [ :each | 
			(removed includes: each dataElement)
				| (removed includes: each targetElement) ].
	removedLinks := actions \ linksPick.
	executor showLinkFields: addedLinks.
	executor hideElements: (removedLinks collect: #linkField)"
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

{ #category : #opening }
OPShowHideElementsBrowser >> startOn: aDiagramController [
	diagramController := aDiagramController
]
