"
I am a tree view of a model.

To define model-specific mappings subclass OPNavigatorAdapter.


"
Class {
	#name : #OPModelNavigator,
	#superclass : #OPModelTreeWidget,
	#category : #'OpenPonk-Spec-Windows'
}

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
