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
		'refreshButton',
		'expandedViewModels',
		'projectController'
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

{ #category : 'private' }
OPProjectTree >> captureExpandedViewModels [
	| capturedViewModels |
	tree roots ifEmpty: [ ^ self ].
	capturedViewModels := IdentitySet new.
	tree roots withIndexDo: [ :eachRootViewModel :rootIndex |
		self captureExpandedViewModelsOf: eachRootViewModel atPath: { rootIndex } into: capturedViewModels ].
	expandedViewModels := capturedViewModels
]

{ #category : 'private' }
OPProjectTree >> captureExpandedViewModelsOf: aViewModel atPath: aPath into: anIdentitySet [
	(tree isExpanded: aPath) ifFalse: [ ^ self ].
	anIdentitySet add: aViewModel.
	(tree childrenFor: aViewModel) withIndexDo: [ :eachChildViewModel :childIndex |
		self
			captureExpandedViewModelsOf: eachChildViewModel
			atPath: (aPath copyWith: childIndex)
			into: anIdentitySet ]
]

{ #category : 'private' }
OPProjectTree >> currentShowIndex [
	"Answer the index of the first visible row in the tree widget, or nil if the widget is not built."
	^ tree adapter ifNotNil: [ :treeAdapter |
		treeAdapter widget ifNotNil: [ :tableWidget |
			tableWidget showIndex ] ]
]

{ #category : 'actions' }
OPProjectTree >> expandToDepth: maxDepthInteger [
	tree roots withIndexDo: [ :eachRootViewModel :rootIndex |
		self
			expandViewModel: eachRootViewModel
			atPath: { rootIndex }
			currentDepth: 1
			maxDepth: maxDepthInteger ]
]

{ #category : 'private' }
OPProjectTree >> expandViewModel: aViewModel atPath: aPath currentDepth: currentDepthInteger maxDepth: maxDepthInteger [
	currentDepthInteger <= maxDepthInteger ifFalse: [ ^ self ].
	tree expandPath: aPath.
	self expandedViewModels add: aViewModel.
	currentDepthInteger < maxDepthInteger ifTrue: [
		(tree childrenFor: aViewModel) withIndexDo: [ :eachChildViewModel :childIndex |
			self
				expandViewModel: eachChildViewModel
				atPath: (aPath copyWith: childIndex)
				currentDepth: currentDepthInteger + 1
				maxDepth: maxDepthInteger ] ]
]

{ #category : 'accessing' }
OPProjectTree >> expandedViewModels [
	"Answer the set of currently expanded view models."
	^ expandedViewModels ifNil: [ expandedViewModels := IdentitySet new ]
]

{ #category : 'event handling' }
OPProjectTree >> handleExpandChanged: anAnnouncement [
	anAnnouncement expanded
		ifTrue: [ self expandedViewModels add: anAnnouncement item ]
		ifFalse: [ self expandedViewModels remove: anAnnouncement item ifAbsent: [ ] ]
]

{ #category : 'initialization' }
OPProjectTree >> initialize [
	super initialize.
	expandedViewModels := IdentitySet new
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
		roots: #();
		contextMenu: [ self buildContextMenu ];
		display: [ :aViewModel | aViewModel modelDisplayString ];
		children: [ :aViewModel |
			aViewModel children sorted: [ :childViewModelA :childViewModelB |
				childViewModelA displayString < childViewModelB displayString ] ];
		displayIcon: [ :aViewModel | aViewModel icon ].
	tree whenExpandChangedDo: [ :anAnnouncement |
		self handleExpandChanged: anAnnouncement ]
]

{ #category : 'initialization' }
OPProjectTree >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	aWindow initialExtent: 600 @ 800
]

{ #category : 'accessing' }
OPProjectTree >> openOn: aProjectViewModel [
	projectViewModel := aProjectViewModel.
	expandedViewModels := IdentitySet new.
	self projectController undoManager announcer weak
		when: OPUndoRedoChanged
		send: #undoRedoChanged:
		to: self.
	self refresh
]

{ #category : 'accessing' }
OPProjectTree >> projectController [
	"Answer the active project controller for this tree."
	^ projectController ifNil: [
		owner ifNotNil: [ :activeOwner | activeOwner projectController ] ]
]

{ #category : 'accessing' }
OPProjectTree >> projectController: aProjectController [
	"Set the active project controller for this tree."
	projectController := aProjectController
]

{ #category : 'accessing' }
OPProjectTree >> projectViewModel [
	"Answer the project view model currently displayed in this tree."
	^ projectViewModel
]

{ #category : 'actions' }
OPProjectTree >> refresh [
	| savedShowIndex |
	savedShowIndex := self currentShowIndex.
	self captureExpandedViewModels.
	tree roots: { projectViewModel }.
	self expandedViewModels isEmpty
		ifTrue: [ self expandToDepth: 3 ]
		ifFalse: [ self restoreExpansion ].
	self restoreShowIndex: savedShowIndex
]

{ #category : 'accessing - spec' }
OPProjectTree >> refreshButton [
	^ refreshButton
]

{ #category : 'actions' }
OPProjectTree >> restoreExpansion [
	tree roots withIndexDo: [ :eachRootViewModel :rootIndex |
		self restoreExpansionOf: eachRootViewModel atPath: { rootIndex } ]
]

{ #category : 'private' }
OPProjectTree >> restoreExpansionOf: aViewModel atPath: aPath [
	(self expandedViewModels includes: aViewModel) ifFalse: [ ^ self ].
	tree expandPath: aPath.
	(tree childrenFor: aViewModel) withIndexDo: [ :eachChildViewModel :childIndex |
		self restoreExpansionOf: eachChildViewModel atPath: (aPath copyWith: childIndex) ]
]

{ #category : 'private' }
OPProjectTree >> restoreShowIndex: aRowIndex [
	"Restore the viewport so that aRowIndex becomes the first visible row, if the widget is built."
	(aRowIndex isNil or: [ aRowIndex <= 1 ]) ifTrue: [ ^ self ].
	tree adapter ifNotNil: [ :treeAdapter |
		treeAdapter widget ifNotNil: [ :tableWidget |
			| targetRowIndex |
			targetRowIndex := (aRowIndex min: tableWidget numberOfRows) max: 1.
			targetRowIndex > 1 ifTrue: [
				tableWidget moveShowIndexTo: targetRowIndex ] ] ]
]

{ #category : 'private' }
OPProjectTree >> selectedItem [

	^ tree selectedItem
]

{ #category : 'accessing - spec' }
OPProjectTree >> tree [
	^ tree
]

{ #category : 'event handling' }
OPProjectTree >> undoRedoChanged: anAnnouncement [
	"Refresh project tree content only when the recorded command affects the domain model."
	(anAnnouncement command isNil or: [ anAnnouncement command affectsModel ])
		ifTrue: [ self refresh ]
]

{ #category : 'accessing' }
OPProjectTree >> viewModelRegistry [

	^ self projectController viewModelRegistry
]

{ #category : 'accessing - spec' }
OPProjectTree >> workbench [
	^ owner workbench
]
