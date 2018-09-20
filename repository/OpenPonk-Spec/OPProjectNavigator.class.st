"
I am a tree view of a project.

To define model-specific mappings subclass OPNavigatorAdapter.
"
Class {
	#name : #OPProjectNavigator,
	#superclass : #OPModelTreeWidget,
	#classVars : [
		'Icons'
	],
	#category : 'OpenPonk-Spec-Windows'
}

{ #category : #'as yet unclassified' }
OPProjectNavigator class >> contextMenu: aBuilder [
	<opModelNavigatorContextMenu>
	| navigator |
	navigator := aBuilder model.
	(aBuilder item: 'Inspect') action: [ navigator selectedItem inspect ]
]

{ #category : #specs }
OPProjectNavigator class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #heading height: self toolbarHeight;
		add: #tree;
		yourself
]

{ #category : #'as yet unclassified' }
OPProjectNavigator class >> openOn: aProject [
	^ self new
		openOn: aProject;
		openWithSpec
]

{ #category : #specs }
OPProjectNavigator class >> withoutHeadingSpec [
	^ SpecColumnLayout composed
		add: #tree;
		yourself
]

{ #category : #accessing }
OPProjectNavigator >> openOn: aProject [
	project := aProject.
	tree roots: {project}.
	project whenChanged: [ tree updateTree ].
	self whenBuiltDo: [ tree expandRoots ]
]

{ #category : #initialization }
OPProjectNavigator >> title [
	^ 'Project Tree'
]
