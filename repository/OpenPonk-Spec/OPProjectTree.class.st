"
Spec presenter that displays the domain model entities and diagram views of the current project in a hierarchical tree structure. 
Interacts with the OPViewModelRegistry to build the tree and provides context menus for model manipulation.
"
Class {
	#name : 'OPProjectTree',
	#superclass : 'SpPresenter',
	#instVars : [
		'tree',
		'projectViewModel',
		'refreshButton'
	],
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'layout' }
OPProjectTree class >> defaultLayout [

	^ SpTabLayout new
		  add: (SpBoxLayout newTopToBottom
				   add: (SpBoxLayout newLeftToRight
						    addLast: #refreshButton
						    withConstraints: [ :constraints | constraints width: 25 ];
						    yourself)
				   height: self toolbarHeight;
				   add: #tree;
				   yourself)
		  label: self title;
		  yourself
]

{ #category : 'specs' }
OPProjectTree class >> title [
	^ 'Project Tree'
]

{ #category : 'menu' }
OPProjectTree >> buildContextMenu [

	| rootGroup |
	self selectedItem ifNil: [ ^ nil ].

	rootGroup := CmCommandGroup forSpec.
	rootGroup beRoot.

	(OPProjectTreeCommand allSubclasses reject: [ :each |
		 each isAbstract ]) do: [ :cmdClass |
			| cmd |
			cmd := cmdClass new.
			cmd context: self.
			cmd canBeExecuted ifTrue: [ rootGroup register: cmd asSpecCommand ] ].
	^ rootGroup asMenuPresenter
]

{ #category : 'initialization' }
OPProjectTree >> initializePresenters [

	self initializeTree.
	refreshButton := self newButton.
	refreshButton
		icon: (self iconNamed: #glamorousRefresh);
		action: [ self refresh ]
]

{ #category : 'initialization' }
OPProjectTree >> initializeTree [

	tree := self newTree.
	tree
		roots: #(  );
		contextMenu: [ self buildContextMenu ];
		display: [ :aViewModel | aViewModel modelDisplayString ];
		children: [ :aViewModel |
				aViewModel children sorted: [ :a :b |
						a displayString < b displayString ] ];
		displayIcon: [ :aViewModel | aViewModel icon ];
		expandRoots
]

{ #category : 'initialization' }
OPProjectTree >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	aWindow initialExtent: 600 @ 800
]

{ #category : 'accessing' }
OPProjectTree >> openOn: aProjectViewModel [

	projectViewModel := aProjectViewModel.
	projectViewModel unsubscribe: self.
	self whenWindowClosedUnsubscribeFrom: projectViewModel.
	projectViewModel weakWhenChangedSend: #refresh to: self.
	self refresh
]

{ #category : 'accessing' }
OPProjectTree >> projectController [

	^ self workbench projectController
]

{ #category : 'actions' }
OPProjectTree >> refresh [

	tree
		roots: { projectViewModel };
		expandRoots
]

{ #category : 'accessing - spec' }
OPProjectTree >> refreshButton [
	^ refreshButton
]

{ #category : 'private' }
OPProjectTree >> selectedItem [

	^ tree selectedItem
]

{ #category : 'accessing - spec' }
OPProjectTree >> tree [
	^ tree
]

{ #category : 'accessing' }
OPProjectTree >> viewModelRegistry [

	^ self projectController viewModelRegistry
]

{ #category : 'accessing - spec' }
OPProjectTree >> workbench [
	^ owner workbench
]
