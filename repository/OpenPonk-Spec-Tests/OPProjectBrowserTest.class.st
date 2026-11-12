"
Tests project tree presentation, item selection, and context menu population in the project browser.
"
Class {
	#name : 'OPProjectBrowserTest',
	#superclass : 'TestCase',
	#instVars : [
		'browser',
		'window'
	],
	#category : 'OpenPonk-Spec-Tests-Windows',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Windows'
}

{ #category : 'running' }
OPProjectBrowserTest >> setUp [
	| testRegistry |
	super setUp.
	OPPluginRegistry setDefaultForTesting.
	testRegistry := OPPluginRegistry new.
	testRegistry add: OPTestPlugin new.
	testRegistry add: OPTestSecondaryPlugin new.
	browser := OPProjectBrowser newApplication: SpApplication defaultApplication model: testRegistry
]

{ #category : 'running' }
OPProjectBrowserTest >> tearDown [
	window ifNotNil: [ :activeWindow | activeWindow close ].
	browser ifNotNil: [ :activeBrowser |
		activeBrowser withWindowDo: [ :activeWindow | activeWindow close ] ].
	OPPluginRegistry resetDefault.
	super tearDown
]

{ #category : 'tests' }
OPProjectBrowserTest >> testBrowserWindowBuildsCleanlyWithProjects [

	| testStorage projectSaved projectUnsaved |
	testStorage := OPProjectStorage new.
	projectSaved := OPProject name: 'SavedPrj'.
	projectSaved storageFile: FileSystem memory root / 'saved.opp'.
	projectUnsaved := OPProject name: 'UnsavedPrj'.
	testStorage add: projectSaved.
	testStorage add: projectUnsaved.
	browser recentList items: testStorage projects.

	window := browser asWindow.
	window build.
	self assert: window isNotNil description: 'OPProjectBrowser should build a window presenter'.
	self assert: window presenter equals: browser
]

{ #category : 'tests' }
OPProjectBrowserTest >> testClassOpenAndUpdateRecentList [
	| openedWindow |
	browser updateRecentList.
	openedWindow := OPProjectBrowser open.
	[
		self assert: openedWindow isNotNil
	] ensure: [
		openedWindow ifNotNil: [
			(openedWindow respondsTo: #close) ifTrue: [ openedWindow close ].
			(openedWindow respondsTo: #withWindowDo:) ifTrue: [
				openedWindow withWindowDo: [ :activeWindow | activeWindow close ] ] ] ]
]

{ #category : 'tests' }
OPProjectBrowserTest >> testCreateProjectButtonDisabledWhenProjectNameEmpty [
	browser projectNameInput text: ''.
	self
		deny: browser createProjectButton isEnabled
		description: 'Create project button must be disabled when project name is empty'.
	browser projectNameInput text: 'ValidProjectName'.
	self
		assert: browser createProjectButton isEnabled
		description: 'Create project button should be enabled when project name is non-empty'
]

{ #category : 'tests' }
OPProjectBrowserTest >> testCreateProjectDispatchesToOpenProject [
	| selectedTemplate openedProjects |
	selectedTemplate := browser templatesList selectedItem.
	self
		assert: selectedTemplate isNotNil
		description: 'Project browser should have a default template selected'.
	openedProjects := OrderedCollection new.
	(browser stub openProject: Any) will: [ :passedProject |
		openedProjects add: passedProject.
		nil ].
	browser createProject.
	self assert: openedProjects size equals: 1.
	self assert: openedProjects first name equals: browser projectName.
	self denyEmpty: openedProjects first models
]

{ #category : 'tests' }
OPProjectBrowserTest >> testFileReaderServicesAndMenuRegistration [
	| oppServices txtServices service builder openPonkItem |
	oppServices := OPProjectBrowser fileReaderServicesForFile: 'model.opp' suffix: 'opp'.
	self assert: oppServices size equals: 1.
	service := oppServices first.
	self assert: service selector equals: #openProjectFromFile:.

	txtServices := OPProjectBrowser fileReaderServicesForFile: 'notes.txt' suffix: 'txt'.
	self assertEmpty: txtServices.

	builder := PragmaMenuBuilder new.
	OPProjectBrowser menuCommandOn: builder.
	openPonkItem := builder itemNamed: #OpenPonk.
	self
		assert: openPonkItem isNotNil
		description: 'menuCommandOn: should register OpenPonk world menu item'
]

{ #category : 'tests' }
OPProjectBrowserTest >> testOpenProjectOpenFromFileAndRecentContextMenu [
	| projectToOpen mockWorkbench returnedWb sourceProject sourceCtrl archiveFile mockOpenPresenter capturedBlock openedFromDialog openedFromFile nilMenu validMenu |
	capturedBlock := nil.
	projectToOpen := OPProject name: 'Browser Opened Project'.
	[
		mockWorkbench := Mock new.
		projectToOpen stub open willReturn: mockWorkbench.
		returnedWb := browser openProject: projectToOpen.
		self assert: returnedWb identicalTo: mockWorkbench.
		self
			assert: (OPProjectStorage default projects includes: projectToOpen)
			description: 'openProject: should save project in OPProjectStorage default'.

		nilMenu := browser projectMenu: browser newMenu for: nil.
		self assertEmpty: nilMenu menuGroups.

		validMenu := browser projectMenu: browser newMenu for: projectToOpen.
		self denyEmpty: validMenu menuGroups.
		validMenu menuGroups first menuItems first action value.
		self
			deny: (OPProjectStorage default projects includes: projectToOpen)
			description: 'Remove context menu item should remove project from OPProjectStorage default'
	] ensure: [ OPProjectStorage default ensureRemove: projectToOpen ].

	sourceProject := OPProject name: 'Archive Project'.
	sourceProject addModel: (OPTestContainerModel new name: 'Pkg'; yourself).
	sourceProject ensureModelsHaveDiagrams.
	sourceCtrl := OPProjectController forProject: sourceProject.
	archiveFile := FileSystem memory root / 'browser-open.opp'.
	sourceCtrl saveProjectTo: archiveFile.

	(browser stub openProject: Any) will: [ :proj | proj ].
	openedFromFile := browser openProjectFromFile: archiveFile.
	self assert: openedFromFile name equals: 'Archive Project'.

	mockOpenPresenter := Mock new.
	StOpenFilePresenter stub new willReturn: mockOpenPresenter.
	mockOpenPresenter stub title: Any.
	mockOpenPresenter stub extensions: Any named: Any.
	mockOpenPresenter stub okAction: [ :block | capturedBlock := block ].
	mockOpenPresenter stub open.

	browser openProjectFromFile.
	openedFromDialog := capturedBlock value: archiveFile.
	self assert: openedFromDialog name equals: 'Archive Project'
]

{ #category : 'tests' }
OPProjectBrowserTest >> testOpenRecentButtonActionOpensSelectedProject [
	| testStorage projectA openedProjects |
	testStorage := OPProjectStorage new.
	projectA := OPProject named: 'ProjectA'.
	testStorage add: projectA.
	browser recentList items: testStorage projects.
	browser recentList selectIndex: 1.

	openedProjects := OrderedCollection new.
	(browser stub openProject: Any) will: [ :passedProject |
		openedProjects add: passedProject.
		nil ].

	browser openRecentButton click.
	self assert: openedProjects size equals: 1.
	self assert: openedProjects first equals: projectA
]

{ #category : 'tests' }
OPProjectBrowserTest >> testOpenRecentButtonStateFollowsSelection [
	| testStorage projectA |
	testStorage := OPProjectStorage new.
	projectA := OPProject name: 'ProjectA'.
	testStorage add: projectA.
	browser recentList items: testStorage projects.

	self
		deny: browser openRecentButton isEnabled
		description: 'Open recent button must be disabled before any recent project is selected'.
	browser recentList selectIndex: 1.
	self
		assert: browser openRecentButton isEnabled
		description: 'Open recent button should be enabled when a recent project is selected'.
	browser recentList selectIndex: 0.
	self
		deny: browser openRecentButton isEnabled
		description: 'Open recent button must be disabled again when selection is cleared'
]

{ #category : 'tests' }
OPProjectBrowserTest >> testPluginSelectionUpdatesTemplates [
	| plugins firstPlugin secondPlugin |
	plugins := browser pluginsList items.
	self
		assert: plugins size >= 2
		description: 'Test environment should have at least 2 plugins registered'.
	firstPlugin := plugins first.
	secondPlugin := plugins second.
	browser pluginsList selectItem: firstPlugin.
	self assertCollection: browser templatesList items hasSameElements: firstPlugin projectTemplates.
	browser pluginsList selectItem: secondPlugin.
	self assertCollection: browser templatesList items hasSameElements: secondPlugin projectTemplates
]

{ #category : 'tests' }
OPProjectBrowserTest >> testPluginsListInitialized [
	self assert: browser pluginsList class equals: SpListPresenter.
	self assert: browser pluginsList items size equals: 2.
	self assertCollection: browser pluginsList items hasSameElements: browser pluginRegistry plugins
]

{ #category : 'tests' }
OPProjectBrowserTest >> testProjectNameStripsEmptyPrefixAndExampleTemplateCreation [
	| exampleTemplate stubWorkbench |
	browser projectNameInput text: 'Empty Class Diagram'.
	self assert: browser projectName equals: 'Class Diagram'.
	browser projectNameInput text: 'Custom Project'.
	self assert: browser projectName equals: 'Custom Project'.

	self assert: browser openFromFileButton class equals: SpButtonPresenter.
	self assert: browser quickStartLabel class equals: SpLabelPresenter.
	self assert: browser recentLabel class equals: SpLabelPresenter.

	browser updateTemplatesListFor: nil.
	self assertEmpty: browser templatesList items.
	browser createProject.

	exampleTemplate := OPProjectTemplate new
		name: 'Example Template';
		isExample: true;
		modelFactory: [ OPTestContainerModel new name: 'PreservedExampleName'; yourself ];
		yourself.
	browser templatesList items: { exampleTemplate }.
	browser templatesList selectIndex: 1.

	stubWorkbench := OPWorkbench new.
	stubWorkbench stub showAllElementsInAllDiagrams willReturn: nil.
	(browser stub openProject: Any) willReturn: stubWorkbench.

	browser createProject.
	stubWorkbench should receive showAllElementsInAllDiagrams
]

{ #category : 'tests' }
OPProjectBrowserTest >> testRecentListDisplaysProjectsWithAndWithoutStorageFile [
	| savedProject unsavedProject testStorage itemStrings |
	testStorage := OPProjectStorage new.
	savedProject := OPProject name: 'SavedPrj'.
	savedProject storageFile: (FileSystem memory root / 'saved.opp').
	unsavedProject := OPProject name: 'UnsavedPrj'.
	testStorage add: savedProject.
	testStorage add: unsavedProject.

	browser recentList items: testStorage projects.
	itemStrings := browser recentList items collect: [ :each |
		browser recentList displayValueFor: each ].

	self assert: itemStrings size equals: 2.
	self
		assert: (itemStrings anySatisfy: [ :each | each includesSubstring: 'SavedPrj [saved.opp]' ])
		description: 'Recent list should display the storage file basename for saved projects'.
	self
		assert: (itemStrings anySatisfy: [ :each | each includesSubstring: 'UnsavedPrj [in image - unsaved]' ])
		description: 'Recent list should mark projects without storageFile as in image - unsaved'
]

{ #category : 'tests' }
OPProjectBrowserTest >> testTemplateSelectionUpdatesProjectNameInput [

	| template |
	self denyEmpty: browser templatesList items.
	template := browser templatesList items last.
	browser templatesList selectItem: template.
	self assert: browser projectNameInput text equals: template name
]

{ #category : 'tests' }
OPProjectBrowserTest >> testTemplatesListInitialized [

	self assert: browser templatesList class equals: SpListPresenter.
	self denyEmpty: browser templatesList items
]
