"
I am a tree view of a project.

To define model-specific mappings subclass OPNavigatorAdapter.
"
Class {
	#name : #OPProjectNavigator,
	#superclass : #OPModelTreeWidget,
	#category : #'OpenPonk-Spec-Windows'
}

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
	tree expandRoots
]

{ #category : #initialization }
OPProjectNavigator >> title [
	^ 'Project Tree'
]
