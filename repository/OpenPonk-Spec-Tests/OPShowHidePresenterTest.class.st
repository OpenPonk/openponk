"
Verifies OPShowHidePresenter, OPCherryPickShowHidePresenter, and OPTypesShowHidePresenter element visibility toggling and announcements.
"
Class {
	#name : 'OPShowHidePresenterTest',
	#superclass : 'OPAbstractUITest',
	#instVars : [
		'entityA',
		'entityB',
		'diagram',
		'projectController',
		'diagramController',
		'pluginRegistry',
		'window'
	],
	#category : 'OpenPonk-Spec-Tests-Dialogs',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Dialogs'
}

{ #category : 'running' }
OPShowHidePresenterTest >> setUp [

	| editor testCanvas project container workbench |
	super setUp.
	pluginRegistry := OPPluginRegistry new.
	pluginRegistry add: OPTestPlugin new.
	project := OPProject new.
	container := OPTestContainerModel new.
	entityA := OPTestEntityModel new.
	entityB := OPTestEntityModel new.
	container
		add: entityA;
		add: entityB.
	project addModel: container.
	testCanvas := RSCanvas new.
	diagram := OPOpenPonkDiagram forModelElement: container.
	diagram canvas: testCanvas.
	project addDiagram: diagram.
	workbench := OPWorkbench new.
	workbench pluginRegistry: pluginRegistry.
	projectController := OPProjectController forProject: project.
	projectController workbench: workbench.
	workbench instVarNamed: #projectController put: projectController.
	editor := OPEditor new.
	editor instVarNamed: #workbench put: workbench.
	diagramController := OPTestDiagramController new.
	diagramController instVarNamed: #editor put: editor.
	projectController addDiagramController: diagramController.
	diagramController
		model: container;
		diagramElement: diagram;
		canvasPresenter: (OPCanvasPresenter new
				 canvas: testCanvas;
				 yourself).
	diagramController showInDiagramModel: entityA.
	window := nil
]

{ #category : 'running' }
OPShowHidePresenterTest >> tearDown [

	window ifNotNil: [ :theWindow | theWindow close ].
	super tearDown
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testCherryPickAndTypesPresentersToggleVisibility [

	| cherryPick typesPresenter viewModelA viewModelB selectedAnnouncements unselectedAnnouncements rootTypeNode |
	viewModelA := projectController viewModelRegistry viewModelFor: entityA.
	viewModelB := projectController viewModelRegistry viewModelFor: entityB.
	cherryPick := OPCherryPickShowHidePresenter on: diagramController.
	self assert: cherryPick hasIcon description: 'OPCherryPickShowHidePresenter should provide icons for view models'.
	self assert: (cherryPick isSelected: viewModelA) description: 'Entity A is shown in diagram and should be marked selected'.
	self deny: (cherryPick isSelected: viewModelB) description: 'Entity B is not shown in diagram and should not be marked selected'.
	selectedAnnouncements := OrderedCollection new.
	unselectedAnnouncements := OrderedCollection new.
	cherryPick whenSelectionChangedDo: [ :ann |
			(ann isKindOf: OPShowHideElementsSelected)
				ifTrue: [ selectedAnnouncements add: ann ]
				ifFalse: [ unselectedAnnouncements add: ann ] ].
	cherryPick processAndUpdateSelected: viewModelB.
	self
		assert: (diagramController hasControllerForModel: entityB)
		description: 'Selecting viewModelB in cherry-pick presenter should show entityB in diagram'.
	self assert: selectedAnnouncements size equals: 1.
	cherryPick processAndUpdateUnselected: viewModelA.
	self
		deny: (diagramController hasControllerForModel: entityA)
		description: 'Unselecting viewModelA in cherry-pick presenter should hide entityA from diagram'.
	self assert: unselectedAnnouncements size equals: 1.
	typesPresenter := OPTypesShowHidePresenter on: diagramController.
	self assert: typesPresenter hasIcon description: 'OPTypesShowHidePresenter should provide icons for type nodes and elements'.
	rootTypeNode := typesPresenter initialRoots first.
	self denyEmpty: (typesPresenter nameFor: rootTypeNode).
	typesPresenter processAndUpdateUnselected: rootTypeNode.
	self
		deny: (diagramController hasControllerForModel: entityB)
		description: 'Unselecting root type node should hide remaining shown entities'.
	typesPresenter processAndUpdateSelected: rootTypeNode.
	self
		assert: (diagramController hasControllerForModel: entityA)
		description: 'Selecting root type node should show entityA in diagram'.
	self
		assert: (diagramController hasControllerForModel: entityB)
		description: 'Selecting root type node should show entityB in diagram'
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testCherryPickPresenterRootTriStateAndNonRootTwoState [

	| rootViewModel viewModelA viewModelB cherryPick tree rootCell rootButtonMorph |
	rootViewModel := diagramController viewModel.
	viewModelA := projectController viewModelRegistry viewModelFor: entityA.
	viewModelB := projectController viewModelRegistry viewModelFor: entityB.
	cherryPick := OPCherryPickShowHidePresenter on: diagramController.

	self assert: (cherryPick selectionStateFor: rootViewModel) equals: #partial.
	self assert: (cherryPick selectionStateFor: viewModelA) equals: #checked.
	self assert: (cherryPick selectionStateFor: viewModelB) equals: #unchecked.

	window := cherryPick open.
	tree := cherryPick instVarNamed: #tree.
	rootCell := tree adapter widget dataSource cellColumn: tree adapter widget columns first row: 1.
	rootButtonMorph := rootCell allMorphs detect: [ :each | each isKindOf: ThreePhaseButtonMorph ].
	self assert: rootButtonMorph formSet equals: (Smalltalk ui icons iconFormSetNamed: #partialCheckedBox).

	rootButtonMorph doButtonAction: nil.
	self
		assert: (diagramController hasControllerForModel: entityB)
		description: 'Clicking partial diagram root must show all remaining elements'.
	self assert: (cherryPick selectionStateFor: rootViewModel) equals: #checked.

	cherryPick processAndUpdateUnselected: rootViewModel.
	self deny: (diagramController hasControllerForModel: entityA) description: 'Unselecting diagram root must hide entityA'.
	self deny: (diagramController hasControllerForModel: entityB) description: 'Unselecting diagram root must hide entityB'.
	self assert: (cherryPick selectionStateFor: rootViewModel) equals: #unchecked.
	self assertEmpty: cherryPick selectedItems
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testEmptyDiagramShowsUncheckedRootInBothPresenters [

	| emptyContainer emptyDiagram emptyController emptyCherryPick emptyTypes rootTypeNode |
	emptyContainer := OPTestContainerModel new.
	emptyDiagram := OPOpenPonkDiagram forModelElement: emptyContainer.
	emptyDiagram canvas: RSCanvas new.
	emptyController := OPTestDiagramController new.
	emptyController instVarNamed: #editor put: diagramController editor.
	projectController addDiagramController: emptyController.
	emptyController
		model: emptyContainer;
		diagramElement: emptyDiagram;
		canvasPresenter: (OPCanvasPresenter new
				 canvas: emptyDiagram canvas;
				 yourself).

	emptyCherryPick := OPCherryPickShowHidePresenter on: emptyController.
	emptyTypes := OPTypesShowHidePresenter on: emptyController.
	rootTypeNode := emptyTypes initialRoots first.

	self assert: (emptyCherryPick selectionStateFor: emptyController viewModel) equals: #unchecked.
	self assert: (emptyTypes selectionStateFor: rootTypeNode) equals: #unchecked
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testShowHidePresenterPagesInitialization [
	| presenter |
	presenter := OPShowHidePresenter on: diagramController.
	self assert: (presenter instVarNamed: #notebook) pages size equals: 2.
	presenter refreshCurrentPage
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testShowHidePresenterWindowAndTabSwitching [

	| presenter notebook cherryPick typesPresenter expectedTitle |
	presenter := OPShowHidePresenter on: diagramController.
	self assert: presenter defaultKeyboardFocus identicalTo: presenter.

	window := presenter open.
	expectedTitle := String streamContents: [ :stream | stream << 'Show / Hide Elements in ' << diagram name << ' - OpenPonk' ].
	self assert: window title equals: expectedTitle.
	notebook := presenter instVarNamed: #notebook.
	self assert: notebook pages size equals: 2.
	cherryPick := notebook selectedPage activePresenter.
	self assert: cherryPick class identicalTo: OPCherryPickShowHidePresenter.
	self assert: presenter defaultKeyboardFocus identicalTo: cherryPick.
	self denyEmpty: cherryPick selectedItems.

	notebook selectPage: notebook pages second.
	presenter refreshCurrentPage.
	typesPresenter := notebook selectedPage activePresenter.
	self assert: typesPresenter class identicalTo: OPTypesShowHidePresenter.
	self denyEmpty: typesPresenter selectedItems
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testShowHideSelectionChangedExposesElements [

	| selectedAnnouncement unselectedAnnouncement |
	selectedAnnouncement := OPShowHideElementsSelected elements: { entityA }.
	unselectedAnnouncement := OPShowHideElementsUnselected elements: { entityB }.

	self assert: selectedAnnouncement elements equals: { entityA }.
	self assert: unselectedAnnouncement elements equals: { entityB }
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testTabContentPresenterColumnCallbacksSearchAndCleanBlockSubscription [

	| cherryPick typesPresenter viewModelA viewModelB rootTypeNode subscription tree checkBoxColumn searchBlock |
	viewModelA := projectController viewModelRegistry viewModelFor: entityA.
	viewModelB := projectController viewModelRegistry viewModelFor: entityB.
	cherryPick := OPCherryPickShowHidePresenter on: diagramController.
	typesPresenter := OPTypesShowHidePresenter on: diagramController.
	rootTypeNode := typesPresenter initialRoots first.

	self assert: (typesPresenter iconFor: rootTypeNode) identicalTo: diagramController viewModel icon.

	subscription := cherryPick whenSelectionChangedDo: [ :announcement | announcement elements ].
	[ self assert: subscription subscriber identicalTo: cherryPick ] ensure: [ cherryPick announcer removeSubscription: subscription ].

	tree := cherryPick instVarNamed: #tree.
	checkBoxColumn := tree columns first columns first.
	checkBoxColumn onActivation value: viewModelB.
	self
		assert: (diagramController hasControllerForModel: entityB)
		description: 'Activating checkbox column must show entityB in diagram'.
	checkBoxColumn onDeactivation value: viewModelA.
	self
		deny: (diagramController hasControllerForModel: entityA)
		description: 'Deactivating checkbox column must hide entityA from diagram'.

	searchBlock := tree instVarNamed: #searchBlock.
	self
		assert: (searchBlock value: viewModelA value: (cherryPick nameFor: viewModelA) asString trimBoth asLowercase)
		description: 'Search matching block must match element name case-insensitively'.
	self
		deny: (searchBlock value: viewModelA value: 'nonexistent-search-pattern-xyz')
		description: 'Search matching block must reject unrelated patterns'
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testTypesPresenterExpandsTypeHierarchyOnlyAndListsSortedElements [

	| viewModelA viewModelB kindType typesPresenter tree rootTreeItem classTreeItem kindTreeItem kindNode |
	entityA name: 'Zeta'.
	entityB name: 'Alpha'.
	viewModelA := projectController viewModelRegistry viewModelFor: entityA.
	viewModelB := projectController viewModelRegistry viewModelFor: entityB.
	kindType := OPModelObjectType named: 'Class' withSubtype: (OPModelObjectType named: '«Kind»').
	viewModelA stub modelType willReturn: kindType.
	viewModelB stub modelType willReturn: kindType.

	typesPresenter := OPTypesShowHidePresenter on: diagramController.
	window := typesPresenter open.
	tree := typesPresenter instVarNamed: #tree.
	rootTreeItem := tree adapter widget dataSource rootItem children first.
	classTreeItem := rootTreeItem children first.
	kindTreeItem := classTreeItem children first.
	kindNode := kindTreeItem data.

	self assert: rootTreeItem isExpanded description: 'All root type node must be expanded initially'.
	self assert: classTreeItem isExpanded description: 'Parent Class type node must be expanded initially'.
	self deny: kindTreeItem isExpanded description: 'Leaf stereotype node must stay collapsed initially'.
	self assert: (typesPresenter childrenFor: kindNode) asArray equals: {
			viewModelB.
			viewModelA }.
	self assertEmpty: (typesPresenter childrenFor: viewModelA).
	self assert: (typesPresenter nameFor: viewModelA) equals: viewModelA modelDisplayString
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testTypesPresenterIconsForRootSharedMixedAndElements [

	| containerViewModel viewModelA viewModelB rootIcon redIconA redIconB greenIcon colorFormA colorFormB typesPresenter rootNode entityTypeNode emptyIcon unmatchedNode |
	containerViewModel := diagramController viewModel.
	viewModelA := projectController viewModelRegistry viewModelFor: entityA.
	viewModelB := projectController viewModelRegistry viewModelFor: entityB.
	emptyIcon := Smalltalk ui icons iconNamed: #empty.

	rootIcon := Form extent: 16 @ 16 depth: 32.
	rootIcon fillColor: Color blue.
	redIconA := Form extent: 16 @ 16 depth: 32.
	redIconA fillColor: Color red.
	redIconB := Form extent: 16 @ 16 depth: 32.
	redIconB fillColor: Color red.
	greenIcon := Form extent: 16 @ 16 depth: 32.
	greenIcon fillColor: Color green.

	containerViewModel stub icon willReturn: rootIcon.
	viewModelA stub icon willReturn: redIconA.
	viewModelB stub icon willReturn: redIconB.

	typesPresenter := OPTypesShowHidePresenter on: diagramController.
	rootNode := typesPresenter initialRoots first.
	entityTypeNode := rootNode children first.
	unmatchedNode := OPModelObjectTypeLeafNode withParent: rootNode fromType: (OPModelObjectType named: 'Unmatched').

	self assert: (typesPresenter iconFor: rootNode) identicalTo: rootIcon.
	self assert: (typesPresenter iconFor: viewModelA) identicalTo: redIconA.
	self assert: (typesPresenter iconFor: entityTypeNode) bits equals: redIconA bits.
	self assert: (typesPresenter iconFor: unmatchedNode) identicalTo: emptyIcon.

	viewModelB stub icon willReturn: greenIcon.
	typesPresenter := OPTypesShowHidePresenter on: diagramController.
	entityTypeNode := typesPresenter initialRoots first children first.
	self assert: (typesPresenter iconFor: entityTypeNode) identicalTo: emptyIcon.

	colorFormA := ColorForm extent: 4 @ 4 depth: 8.
	colorFormA colors: {
			Color black.
			Color red }.
	colorFormB := ColorForm extent: 4 @ 4 depth: 8.
	colorFormB colors: {
			Color black.
			Color blue }.
	viewModelA stub icon willReturn: colorFormA.
	viewModelB stub icon willReturn: colorFormB.
	typesPresenter := OPTypesShowHidePresenter on: diagramController.
	entityTypeNode := typesPresenter initialRoots first children first.
	self assert: (typesPresenter iconFor: entityTypeNode) identicalTo: emptyIcon
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testTypesPresenterMixedDepthTypeIncludesDirectElements [

	| viewModelA viewModelB bareClassType kindClassType typesPresenter classNode kindNode tree classTreeItem bareElementTreeItem |
	entityA name: 'BareClass'.
	entityB name: 'StereotypedClass'.
	viewModelA := projectController viewModelRegistry viewModelFor: entityA.
	viewModelB := projectController viewModelRegistry viewModelFor: entityB.
	bareClassType := OPModelObjectType named: 'Class'.
	kindClassType := OPModelObjectType named: 'Class' withSubtype: (OPModelObjectType named: '«Kind»').
	viewModelA stub modelType willReturn: bareClassType.
	viewModelB stub modelType willReturn: kindClassType.

	typesPresenter := OPTypesShowHidePresenter on: diagramController.
	window := typesPresenter open.
	classNode := typesPresenter initialRoots first children first.
	kindNode := classNode children first.
	tree := typesPresenter instVarNamed: #tree.
	classTreeItem := tree adapter widget dataSource rootItem children first children first.
	bareElementTreeItem := classTreeItem children second.

	self assert: (typesPresenter childrenFor: classNode) asArray equals: {
			kindNode.
			viewModelA }.
	self assert: (typesPresenter childrenFor: kindNode) asArray equals: { viewModelB }.
	self deny: bareElementTreeItem isExpanded description: 'Direct element child under parent type must not be expanded'
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testTypesPresenterMultiTypeElementSyncAcrossSubtypes [

	| viewModelA viewModelB multiType kindOnlyType typesPresenter classNode fooNode kindNode |
	entityA name: 'Person'.
	entityB name: 'Dog'.
	viewModelA := projectController viewModelRegistry viewModelFor: entityA.
	viewModelB := projectController viewModelRegistry viewModelFor: entityB.
	multiType := OPModelObjectType named: 'Class' withSubtypes: {
			             (OPModelObjectType named: '«Kind»').
			             (OPModelObjectType named: '«Foo»') }.
	kindOnlyType := OPModelObjectType named: 'Class' withSubtype: (OPModelObjectType named: '«Kind»').
	viewModelA stub modelType willReturn: multiType.
	viewModelB stub modelType willReturn: kindOnlyType.

	typesPresenter := OPTypesShowHidePresenter on: diagramController.
	classNode := typesPresenter initialRoots first children first.
	fooNode := classNode children detect: [ :each | each name = '«Foo»' ].
	kindNode := classNode children detect: [ :each | each name = '«Kind»' ].

	self assert: (typesPresenter childrenFor: fooNode) asArray equals: { viewModelA }.
	self assert: (typesPresenter childrenFor: kindNode) asArray equals: {
			viewModelB.
			viewModelA }.
	self assert: (typesPresenter selectionStateFor: fooNode) equals: #checked.
	self assert: (typesPresenter selectionStateFor: kindNode) equals: #partial.
	self assert: (typesPresenter selectionStateFor: classNode) equals: #partial.
	self assert: (typesPresenter selectionStateFor: viewModelA) equals: #checked.

	typesPresenter processAndUpdateSelected: viewModelB.
	self assert: (typesPresenter selectionStateFor: kindNode) equals: #checked.
	self assert: (typesPresenter selectionStateFor: classNode) equals: #checked.

	typesPresenter processAndUpdateUnselected: fooNode.
	self deny: (diagramController hasControllerForModel: entityA) description: 'Unchecking Foo must hide multi-type Person'.
	self
		assert: (diagramController hasControllerForModel: entityB)
		description: 'Unchecking Foo must not hide Dog which only has Kind'.
	self assert: (typesPresenter selectionStateFor: viewModelA) equals: #unchecked.
	self assert: (typesPresenter selectionStateFor: fooNode) equals: #unchecked.
	self assert: (typesPresenter selectionStateFor: kindNode) equals: #partial.
	self assert: (typesPresenter selectionStateFor: classNode) equals: #partial.

	typesPresenter processAndUpdateSelected: viewModelA.
	self assert: (diagramController hasControllerForModel: entityA) description: 'Re-selecting Person must show it again'.
	self assert: (typesPresenter selectionStateFor: viewModelA) equals: #checked.
	self assert: (typesPresenter selectionStateFor: fooNode) equals: #checked.
	self assert: (typesPresenter selectionStateFor: kindNode) equals: #checked.
	self assert: (typesPresenter selectionStateFor: classNode) equals: #checked
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testTypesPresenterTogglesIndividualElementVisibility [

	| viewModelA viewModelB typesPresenter entityTypeNode |
	viewModelA := projectController viewModelRegistry viewModelFor: entityA.
	viewModelB := projectController viewModelRegistry viewModelFor: entityB.
	typesPresenter := OPTypesShowHidePresenter on: diagramController.
	entityTypeNode := typesPresenter initialRoots first children first.

	self assert: (typesPresenter selectionStateFor: viewModelA) equals: #checked.
	self assert: (typesPresenter selectionStateFor: viewModelB) equals: #unchecked.
	self assert: (typesPresenter selectionStateFor: entityTypeNode) equals: #partial.

	typesPresenter processAndUpdateSelected: viewModelB.
	self assert: (diagramController hasControllerForModel: entityB) description: 'Selecting individual viewModelB must show entityB'.
	self assert: (typesPresenter selectionStateFor: viewModelB) equals: #checked.
	self assert: (typesPresenter selectionStateFor: entityTypeNode) equals: #checked.

	typesPresenter processAndUpdateUnselected: viewModelA.
	self deny: (diagramController hasControllerForModel: entityA) description: 'Unselecting individual viewModelA must hide entityA'.
	self assert: (diagramController hasControllerForModel: entityB) description: 'Hiding entityA must keep sibling entityB shown'.
	self assert: (typesPresenter selectionStateFor: viewModelA) equals: #unchecked.
	self assert: (typesPresenter selectionStateFor: viewModelB) equals: #checked.
	self assert: (typesPresenter selectionStateFor: entityTypeNode) equals: #partial.

	typesPresenter processAndUpdateUnselected: viewModelB.
	self deny: (diagramController hasControllerForModel: entityB) description: 'Unselecting viewModelB must hide entityB'.
	self assert: (typesPresenter selectionStateFor: entityTypeNode) equals: #unchecked
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testTypesPresenterTriStateTransitionsAndPartialClickShowsRemaining [

	| viewModelA viewModelB typesPresenter rootNode entityTypeNode tree cell buttonMorph |
	viewModelA := projectController viewModelRegistry viewModelFor: entityA.
	viewModelB := projectController viewModelRegistry viewModelFor: entityB.
	typesPresenter := OPTypesShowHidePresenter on: diagramController.
	rootNode := typesPresenter initialRoots first.
	entityTypeNode := rootNode children first.

	self assert: (typesPresenter selectionStateFor: viewModelA) equals: #checked.
	self assert: (typesPresenter selectionStateFor: viewModelB) equals: #unchecked.
	self assert: (typesPresenter selectionStateFor: entityTypeNode) equals: #partial.
	self assert: (typesPresenter selectionStateFor: rootNode) equals: #partial.

	window := typesPresenter open.
	tree := typesPresenter instVarNamed: #tree.
	cell := tree adapter widget dataSource cellColumn: tree adapter widget columns first row: 2.
	buttonMorph := cell allMorphs detect: [ :each | each isKindOf: ThreePhaseButtonMorph ].
	self assert: buttonMorph formSet equals: (Smalltalk ui icons iconFormSetNamed: #partialCheckedBox).

	buttonMorph doButtonAction: nil.
	self
		assert: (diagramController hasControllerForModel: entityA)
		description: 'Clicking a partial group must keep already-shown entityA visible'.
	self
		assert: (diagramController hasControllerForModel: entityB)
		description: 'Clicking a partial group must show remaining hidden entityB'.
	self assert: (typesPresenter selectionStateFor: entityTypeNode) equals: #checked.
	self assert: (typesPresenter selectionStateFor: rootNode) equals: #checked.

	cell := tree adapter widget dataSource cellColumn: tree adapter widget columns first row: 2.
	buttonMorph := cell allMorphs detect: [ :each | each isKindOf: ThreePhaseButtonMorph ].
	self assert: buttonMorph formSet equals: (Smalltalk ui icons iconFormSetNamed: #checkedBox).

	buttonMorph doButtonAction: nil.
	self deny: (diagramController hasControllerForModel: entityA) description: 'Clicking a checked group must hide entityA'.
	self deny: (diagramController hasControllerForModel: entityB) description: 'Clicking a checked group must hide entityB'.
	self assert: (typesPresenter selectionStateFor: entityTypeNode) equals: #unchecked.
	self assert: (typesPresenter selectionStateFor: rootNode) equals: #unchecked.

	cell := tree adapter widget dataSource cellColumn: tree adapter widget columns first row: 2.
	buttonMorph := cell allMorphs detect: [ :each | each isKindOf: ThreePhaseButtonMorph ].
	self assert: buttonMorph formSet equals: (Smalltalk ui icons iconFormSetNamed: #uncheckedBox)
]
