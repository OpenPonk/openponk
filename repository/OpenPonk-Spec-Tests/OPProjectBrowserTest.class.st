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
