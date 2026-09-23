Class {
	#name : 'OPProjectBrowserTest',
	#superclass : 'TestCase',
	#instVars : [
		'browser',
		'window'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
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
OPProjectBrowserTest >> testCreateProjectDispatchesToOpenProject [
	| selectedTemplate openedProjects |
	selectedTemplate := browser templatesList selectedItem.
	self assert: selectedTemplate isNotNil.
	openedProjects := OrderedCollection new.
	(browser stub openProject: Any) will: [ :passedProject | 
		openedProjects add: passedProject.
		nil ].
	browser createProject.
	self assert: openedProjects size equals: 1.
	self assert: openedProjects first name equals: browser projectNameInput text.
	self assert: openedProjects first models isNotEmpty
]

{ #category : 'tests' }
OPProjectBrowserTest >> testPluginSelectionUpdatesTemplates [
	| plugins firstPlugin secondPlugin |
	plugins := browser pluginsList items.
	self assert: plugins size >= 2.
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
OPProjectBrowserTest >> testTemplateSelectionUpdatesProjectNameInput [
	| template |
	self assert: browser templatesList items isNotEmpty.
	template := browser templatesList items last.
	browser templatesList selectItem: template.
	self assert: browser projectNameInput text equals: template name
]

{ #category : 'tests' }
OPProjectBrowserTest >> testTemplatesListInitialized [
	self assert: browser templatesList class equals: SpListPresenter.
	self assert: browser templatesList items isNotEmpty
]
