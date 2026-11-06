"
Spec presenter displaying the project, its root domain models, and their associated diagram views in a three-level hierarchical tree. Provides context menus for diagram and model operations and synchronizes selection with the active workbench editor.
"
Class {
	#name : 'OPDiagramsTree',
	#superclass : 'SpPresenter',
	#instVars : [
		'tree',
		'projectViewModel',
		'expandedViewModels',
		'projectController'
	],
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'specs' }
OPDiagramsTree class >> title [
	^ 'Diagrams'
]

{ #category : 'actions' }
OPDiagramsTree >> activateItem: anItem [
	(anItem isNotNil and: [ anItem isDiagramElement ]) ifFalse: [ ^ self ].
	self openDiagram: anItem
]

{ #category : 'menu' }
OPDiagramsTree >> buildContextMenu [
	| selectedNode |
	selectedNode := self selectedItem.
	selectedNode ifNil: [ ^ nil ].
	selectedNode isDiagramElement ifTrue: [
		^ self contextMenuForDiagram: selectedNode ].
	^ self contextMenuForViewModel: selectedNode
]

{ #category : 'private' }
OPDiagramsTree >> captureExpandedViewModels [
	| capturedViewModels |
	tree roots ifEmpty: [ ^ self ].
	capturedViewModels := IdentitySet new.
	tree roots withIndexDo: [ :eachRootViewModel :rootIndex |
		self
			captureExpandedViewModelsOf: eachRootViewModel
			atPath: { rootIndex }
			into: capturedViewModels ].
	expandedViewModels := capturedViewModels
]

{ #category : 'private' }
OPDiagramsTree >> captureExpandedViewModelsOf: aNode atPath: aPath into: anIdentitySet [
	(tree isExpanded: aPath) ifFalse: [ ^ self ].
	anIdentitySet add: aNode.
	(tree childrenFor: aNode) withIndexDo: [ :eachChildNode :childIndex |
		self
			captureExpandedViewModelsOf: eachChildNode
			atPath: (aPath copyWith: childIndex)
			into: anIdentitySet ]
]

{ #category : 'private' }
OPDiagramsTree >> childrenForNode: aNode [
	aNode ifNil: [ ^ #() ].
	aNode isDiagramElement ifTrue: [ ^ #() ].
	aNode = projectViewModel ifTrue: [ 
		^ aNode children sorted: [ :childViewModelA :childViewModelB |
			childViewModelA displayString < childViewModelB displayString ] ].
	^ (self project diagramsOf: aNode model) asArray
]

{ #category : 'menu' }
OPDiagramsTree >> contextMenuForDiagram: aDiagram [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Open diagram';
						action: [ self openDiagram: aDiagram ];
						iconName: #glamorousOpen ];
				addItem: [ :item |
					item
						name: 'Copy diagram...';
						action: [ self copyDiagram: aDiagram ];
						iconName: #smallCopy ];
				addItem: [ :item |
					item
						name: 'Rename diagram';
						action: [ self renameDiagram: aDiagram ];
						iconName: #glamorousEdit ] ];
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Delete diagram';
					action: [ self deleteDiagram: aDiagram ];
					iconName: #glamorousTrash;
					enabled: [ self isDeleteAllowedFor: aDiagram ] ] ];
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Inspect Diagram';
					action: [ aDiagram inspect ];
					iconName: #glamorousInspect ] ];
		yourself
]

{ #category : 'menu' }
OPDiagramsTree >> contextMenuForViewModel: aViewModel [

	| rootGroup menuPresenter |
	rootGroup := CmCommandGroup forSpec.
	rootGroup beRoot.
	(OPProjectTreeCommand allSubclasses reject: [ :eachClass | eachClass isAbstract ]) do: [ :commandClass |
			| command |
			command := commandClass new.
			command context: self.
			command canBeExecuted ifTrue: [ rootGroup register: command asSpecCommand ] ].
	menuPresenter := rootGroup asMenuPresenter.
	^ menuPresenter
]

{ #category : 'actions' }
OPDiagramsTree >> copyDiagram: aDiagram [

	| newName newDiagram |
	newName := nil.
	[
		newName := UIManager default
			           request: 'Copy ' , (self displayForNode: aDiagram) , '. New name: '
			           initialAnswer: 'Copy of ' , aDiagram name
			           title: 'Copy' ] doWhileTrue: [ newName isNotNil and: [ newName isEmpty or: [ newName = aDiagram name ] ] ].
	newName ifNil: [ ^ self ].
	self projectController updateDiagrams.
	newDiagram := self project copyDiagram: aDiagram named: newName.
	self project announcer announce: (OPDiagramAdded diagram: newDiagram).
	self workbench ifNotNil: [ :activeWorkbench | activeWorkbench openEditorOnDiagram: newDiagram ]
]

{ #category : 'actions' }
OPDiagramsTree >> createDiagram [
	| targetModel |
	targetModel := self selectedModelForNewDiagram.
	targetModel ifNil: [ ^ self ].
	self createDiagramForModel: targetModel
]

{ #category : 'actions' }
OPDiagramsTree >> createDiagramForModel: aModel [

	| diagramName |
	diagramName := nil.
	[ diagramName := UIManager default request: 'Diagram name: ' initialAnswer: aModel name title: 'Create new' ] doWhileTrue: [
		diagramName isNotNil and: [ diagramName isEmpty ] ].
	diagramName ifNil: [ ^ self ].
	self createDiagramForModel: aModel named: diagramName
]

{ #category : 'actions' }
OPDiagramsTree >> createDiagramForModel: aModel named: aName [
	| diagram modelViewModel |
	diagram := OPOpenPonkDiagram forModelElement: aModel.
	diagram name: aName.
	modelViewModel := self viewModelRegistry viewModelFor: aModel.
	self expandedViewModels add: modelViewModel.
	self project addDiagram: diagram.
	self project announcer announce: (OPDiagramAdded diagram: diagram).
	self workbench ifNotNil: [ :activeWorkbench |
		activeWorkbench openEditorOnDiagram: diagram ]
]

{ #category : 'private' }
OPDiagramsTree >> currentShowIndex [
	^ tree adapter ifNotNil: [ :treeAdapter |
		treeAdapter widget ifNotNil: [ :tableWidget |
			tableWidget showIndex ] ]
]

{ #category : 'layout' }
OPDiagramsTree >> defaultLayout [
	^ SpTabLayout new
		add: (SpBoxLayout newTopToBottom
			add: tree;
			yourself)
		label: self class title;
		yourself
]

{ #category : 'actions' }
OPDiagramsTree >> deleteDiagram: aDiagram [

	(UIManager default confirm: 'Delete ' , (self displayForNode: aDiagram) , '?' label: 'Delete') ifFalse: [ ^ self ].
	self workbench deleteDiagram: aDiagram.
	self refresh
]

{ #category : 'event handling' }
OPDiagramsTree >> diagramFocused [

	self refresh
]

{ #category : 'event handling' }
OPDiagramsTree >> diagramUnfocused [

	tree unselectAll
]

{ #category : 'private' }
OPDiagramsTree >> displayForNode: aNode [

	aNode isDiagramElement ifTrue: [ ^ aNode name , ' (Diagram)' ].
	^ aNode modelDisplayString
]

{ #category : 'private' }
OPDiagramsTree >> expandNode: aNode atPath: aPath currentDepth: currentDepthInteger maxDepth: maxDepthInteger [
	currentDepthInteger <= maxDepthInteger ifFalse: [ ^ self ].
	tree expandPath: aPath.
	self expandedViewModels add: aNode.
	currentDepthInteger < maxDepthInteger ifTrue: [
		(tree childrenFor: aNode) withIndexDo: [ :eachChildNode :childIndex |
			self
				expandNode: eachChildNode
				atPath: (aPath copyWith: childIndex)
				currentDepth: currentDepthInteger + 1
				maxDepth: maxDepthInteger ] ]
]

{ #category : 'actions' }
OPDiagramsTree >> expandToDepth: maxDepthInteger [
	tree roots withIndexDo: [ :eachRootNode :rootIndex |
		self
			expandNode: eachRootNode
			atPath: { rootIndex }
			currentDepth: 2
			maxDepth: maxDepthInteger ]
]

{ #category : 'accessing' }
OPDiagramsTree >> expandedViewModels [
	^ expandedViewModels ifNil: [ expandedViewModels := IdentitySet new ]
]

{ #category : 'event handling' }
OPDiagramsTree >> handleExpandChanged: anAnnouncement [
	anAnnouncement expanded
		ifTrue: [ self expandedViewModels add: anAnnouncement item ]
		ifFalse: [ self expandedViewModels remove: anAnnouncement item ifAbsent: [ ] ]
]

{ #category : 'private' }
OPDiagramsTree >> iconForNode: aNode [
	aNode isDiagramElement ifTrue: [
		^ (self viewModelRegistry viewModelFor: aNode modelElement) icon ].
	^ aNode icon
]

{ #category : 'initialization' }
OPDiagramsTree >> initialize [
	super initialize.
	expandedViewModels := IdentitySet new
]

{ #category : 'initialization' }
OPDiagramsTree >> initializePresenters [
	self initializeTree
]

{ #category : 'initialization' }
OPDiagramsTree >> initializeTree [
	tree := self newTree.
	tree
		roots: #();
		contextMenu: [ self buildContextMenu ];
		display: [ :aNode | self displayForNode: aNode ];
		children: [ :aNode | self childrenForNode: aNode ];
		displayIcon: [ :aNode | self iconForNode: aNode ];
		whenActivatedDo: [ :selection | self activateItem: selection selectedItem ];
		whenExpandChangedDo: [ :anAnnouncement | self handleExpandChanged: anAnnouncement ]
]

{ #category : 'testing' }
OPDiagramsTree >> isDeleteAllowedFor: aDiagram [
	^ self project isNotNil and: [
		(self project diagramsOf: aDiagram modelElement) size > 1 ]
]

{ #category : 'actions' }
OPDiagramsTree >> openDiagram: aDiagram [
	UIManager default showWaitCursorWhile: [
		self workbench openEditorOnDiagram: aDiagram ]
]

{ #category : 'accessing' }
OPDiagramsTree >> openOn: aProjectViewModel [
	projectViewModel := aProjectViewModel.
	expandedViewModels := IdentitySet new.
	self refresh
]

{ #category : 'accessing' }
OPDiagramsTree >> project [
	^ self projectController ifNotNil: [ :controller | controller project ]
]

{ #category : 'accessing' }
OPDiagramsTree >> projectController [
	^ projectController ifNil: [
		owner ifNotNil: [ :activeOwner | activeOwner projectController ] ]
]

{ #category : 'accessing' }
OPDiagramsTree >> projectController: aProjectController [
	projectController := aProjectController
]

{ #category : 'accessing' }
OPDiagramsTree >> projectViewModel [
	^ projectViewModel
]

{ #category : 'actions' }
OPDiagramsTree >> refresh [
	| savedShowIndex |
	projectViewModel ifNil: [ ^ self ].
	savedShowIndex := self currentShowIndex.
	self captureExpandedViewModels.
	tree roots: { projectViewModel }.
	self expandedViewModels
		ifEmpty: [ self expandToDepth: 3 ]
		ifNotEmpty: [ self restoreExpansion ].
	self restoreShowIndex: savedShowIndex.
	self selectActiveDiagram
]

{ #category : 'actions' }
OPDiagramsTree >> renameDiagram: aDiagram [

	| diagramName |
	diagramName := nil.
	[
	diagramName := UIManager default
		               request: 'Rename ' , (self displayForNode: aDiagram)
		               initialAnswer: aDiagram name
		               title: 'Rename' ] doWhileTrue: [ diagramName isNotNil and: [ diagramName = aDiagram name ] ].
	diagramName ifNil: [ ^ self ].
	self renameDiagram: aDiagram to: diagramName
]

{ #category : 'actions' }
OPDiagramsTree >> renameDiagram: aDiagram to: aNewName [
	self projectController renameDiagram: aDiagram to: aNewName
]

{ #category : 'actions' }
OPDiagramsTree >> restoreExpansion [
	tree roots withIndexDo: [ :eachRootNode :rootIndex |
		self restoreExpansionOf: eachRootNode atPath: { rootIndex } ]
]

{ #category : 'private' }
OPDiagramsTree >> restoreExpansionOf: aNode atPath: aPath [
	(self expandedViewModels includes: aNode) ifFalse: [ ^ self ].
	tree expandPath: aPath.
	(tree childrenFor: aNode) withIndexDo: [ :eachChildNode :childIndex |
		self restoreExpansionOf: eachChildNode atPath: (aPath copyWith: childIndex) ]
]

{ #category : 'private' }
OPDiagramsTree >> restoreShowIndex: aRowIndex [
	(aRowIndex isNil or: [ aRowIndex <= 1 ]) ifTrue: [ ^ self ].
	tree adapter ifNotNil: [ :treeAdapter |
		treeAdapter widget ifNotNil: [ :tableWidget |
			| targetRowIndex |
			targetRowIndex := (aRowIndex min: tableWidget numberOfRows) max: 1.
			targetRowIndex > 1 ifTrue: [
				tableWidget moveShowIndexTo: targetRowIndex ] ] ]
]

{ #category : 'private' }
OPDiagramsTree >> selectActiveDiagram [
	self project ifNil: [ ^ self ].
	self project diagrams
		detect: [ :eachDiagram | eachDiagram isSelected ]
		ifFound: [ :selectedDiagram | tree selectItem: selectedDiagram ]
]

{ #category : 'accessing' }
OPDiagramsTree >> selectedItem [
	^ tree selectedItem
]

{ #category : 'private' }
OPDiagramsTree >> selectedModelForNewDiagram [
	| selectedNode |
	selectedNode := self selectedItem.
	selectedNode ifNotNil: [
		selectedNode isDiagramElement ifTrue: [ ^ selectedNode modelElement ].
		(self project hasModel: selectedNode model) ifTrue: [ ^ selectedNode model ] ].
	self workbench ifNotNil: [ :activeWorkbench |
		activeWorkbench focusedEditor ifNotNil: [ :editor |
			^ editor diagramController model ] ].
	^ self project models ifNotEmpty: [ :models | models first ] ifEmpty: [ nil ]
]

{ #category : 'accessing - spec' }
OPDiagramsTree >> tree [
	^ tree
]

{ #category : 'event handling' }
OPDiagramsTree >> undoRedoChanged: anAnnouncement [
	(anAnnouncement command isNil or: [ anAnnouncement command affectsModel ])
		ifTrue: [ self refresh ]
]

{ #category : 'accessing' }
OPDiagramsTree >> viewModelRegistry [
	^ self projectController viewModelRegistry
]

{ #category : 'accessing - spec' }
OPDiagramsTree >> workbench [
	^ owner ifNotNil: [ :activeOwner | activeOwner workbench ]
]
