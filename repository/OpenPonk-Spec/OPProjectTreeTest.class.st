Class {
	#name : 'OPProjectTreeTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'projectController',
		'projectTree',
		'rootContainer',
		'childContainer',
		'leafEntity'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPProjectTreeTest >> setUp [
	| customPluginRegistry |
	super setUp.
	customPluginRegistry := OPPluginRegistry new.
	customPluginRegistry add: OPTestPlugin new.

	project := OPProject new.
	rootContainer := OPTestContainerModel new.
	childContainer := OPTestContainerModel new.
	leafEntity := OPTestEntityModel new.

	project addModel: rootContainer.
	rootContainer add: childContainer.
	childContainer add: leafEntity.

	projectController := project controllerClass forProject: project.

	projectTree := OPProjectTree new.
	projectTree application: SpApplication defaultApplication.
	projectTree projectController: projectController.
	projectTree openOn: projectController viewModel.
	projectTree build
]

{ #category : 'running' }
OPProjectTreeTest >> tearDown [
	projectTree := nil.
	projectController := nil.
	project := nil.
	super tearDown
]

{ #category : 'tests' }
OPProjectTreeTest >> testBoundsCommandDoesNotTriggerTreeRefresh [
	| treePresenter rootsBeforeChange mockElement boundsCommand |
	treePresenter := projectTree tree.
	rootsBeforeChange := treePresenter roots.

	mockElement := Mock new.

	boundsCommand := OPChangeBoundsCommand new
		element: mockElement
		oldBounds: (0 @ 0 extent: 10 @ 10)
		newBounds: (10 @ 10 extent: 20 @ 20).

	projectController undoManager inTransaction: [
		projectController undoManager execute: boundsCommand ].

	self assert: treePresenter roots identicalTo: rootsBeforeChange
]

{ #category : 'tests' }
OPProjectTreeTest >> testInitialExpansionToDepth3 [
	| treePresenter |
	treePresenter := projectTree tree.
	self assert: (treePresenter isExpanded: #(1)).
	self assert: (treePresenter isExpanded: #(1 1)).
	self assert: (treePresenter isExpanded: #(1 1 1)).
	self deny: (treePresenter isExpanded: #(1 1 1 1))
]

{ #category : 'tests' }
OPProjectTreeTest >> testRefreshPreservesScrollPosition [

	| treeWidget initialShowIndex |
	1 to: 40 do: [ :index |
			| extraContainer |
			extraContainer := OPTestContainerModel new.
			extraContainer name: 'ExtraContainer ' , index asString.
			project addModel: extraContainer.
			project announcer announce: (OPModelAdded model: extraContainer) ].

	projectTree refresh.
	treeWidget := projectTree tree adapter widget.
	treeWidget extent: 300 @ 500.
	treeWidget recalculateVerticalScrollBar.
	treeWidget moveShowIndexTo: 25.
	initialShowIndex := treeWidget showIndex.
	self assert: initialShowIndex > 1.

	projectTree refresh.

	self assert: treeWidget showIndex equals: initialShowIndex
]

{ #category : 'tests' }
OPProjectTreeTest >> testRefreshPreservesUserCollapsedState [
	| treePresenter |
	treePresenter := projectTree tree.
	treePresenter collapsePath: #(1 1 1).
	self deny: (treePresenter isExpanded: #(1 1 1)).

	projectTree refresh.
	self assert: (treePresenter isExpanded: #(1)).
	self assert: (treePresenter isExpanded: #(1 1)).
	self deny: (treePresenter isExpanded: #(1 1 1))
]

{ #category : 'tests' }
OPProjectTreeTest >> testRefreshPreservesUserExpandedState [
	| treePresenter |
	treePresenter := projectTree tree.
	treePresenter expandPath: #(1 1 1 1).
	self assert: (treePresenter isExpanded: #(1 1 1 1)).

	projectTree refresh.
	self assert: (treePresenter isExpanded: #(1 1 1 1))
]
