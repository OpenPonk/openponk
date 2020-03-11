"
I am a tree view of a model.

To define model-specific mappings subclass OPNavigatorAdapter.


"
Class {
	#name : #OPModelNavigator,
	#superclass : #OPModelTreeWidget,
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #'as yet unclassified' }
OPModelNavigator class >> contextMenu: aBuilder [
	<opModelNavigatorContextMenu>
	| navigator |
	navigator := aBuilder model.
	(aBuilder item: 'Inspect') action: [ navigator selectedItem inspect ]
]

{ #category : #specs }
OPModelNavigator class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #heading height: self toolbarHeight;
		add: #tree;
		yourself
]

{ #category : #'as yet unclassified' }
OPModelNavigator class >> openOn: aProject [
	^ self new
		openOn: aProject;
		openWithSpec
]

{ #category : #specs }
OPModelNavigator class >> withoutHeadingSpec [
	^ SpecColumnLayout composed
		add: #tree;
		yourself
]

{ #category : #accessing }
OPModelNavigator >> openOn: aProject [
	self workbench announcer
		when: OPEditorFocused
		do: [ :event | 
			project ifNotNil: [ project announcer unsubscribe: self ].
			project := event diagramController model.
			project ifNotNil: [ project announcer when: OPModelChanged do: [ tree updateTree ] ].
			tree
				roots: {project};
				expandRoots ].
	self whenBuiltDo: [ tree expandRoots ]
]

{ #category : #initialization }
OPModelNavigator >> title [
	^ 'Model Tree'
]
