"
Verifies model type selection presenter initialization, automatic naming, button enablement, and adding a new model to a project.
"
Class {
	#name : 'OPModelTypeSelectorTest',
	#superclass : 'TestCase',
	#instVars : [
		'selectorPresenter'
	],
	#category : 'OpenPonk-Spec-Tests-Windows',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Windows'
}

{ #category : 'running' }
OPModelTypeSelectorTest >> setUp [

	| project projectController pluginRegistry |
	super setUp.
	project := OPProject new.
	projectController := OPProjectController forProject: project.
	pluginRegistry := OPPluginRegistry new.
	pluginRegistry add: OPTestPlugin new.
	selectorPresenter := OPModelTypeSelector on: projectController.
	selectorPresenter instVarNamed: #pluginRegistry put: pluginRegistry.
	selectorPresenter connectPresenters
]

{ #category : 'tests' }
OPModelTypeSelectorTest >> testSelectingPluginUpdatesDefaultModelNameAndEnablesButton [
	| nameInput addButton pluginsList |
	nameInput := selectorPresenter instVarNamed: #projectNameInput.
	addButton := selectorPresenter instVarNamed: #addModelButton.
	pluginsList := selectorPresenter instVarNamed: #plugins.
	self
		deny: pluginsList selectedItem
		equals: nil.
	self
		assert: addButton isEnabled
		description: 'Create button should be enabled when plugin is selected and model name is non-empty'.
	self
		assert: (nameInput text includesSubstring: pluginsList selectedItem name)
		description: 'Default model name should include selected plugin name'.
	nameInput text: ''.
	self
		deny: addButton isEnabled
		description: 'Create button should be disabled when model name input is empty'.
	nameInput text: 'Custom Model Name'.
	self
		assert: addButton isEnabled
		description: 'Create button should be re-enabled when non-empty model name is entered'
]

{ #category : 'tests' }
OPModelTypeSelectorTest >> testSelectionNamePreservationAddModelAndWindowInitialization [
	| project workbench projectController pluginRegistry plugin1 plugin2 nameInput pluginsList window |
	project := OPProject new.
	workbench := Mock new.
	(workbench stub openEditorOnDiagram: Any) willReturn: nil.
	projectController := OPProjectController forProject: project.
	projectController workbench: workbench.
	plugin1 := OPTestPlugin new.
	plugin2 := OPTestSecondaryPlugin new.
	pluginRegistry := OPPluginRegistry new.
	pluginRegistry add: plugin1; add: plugin2.

	selectorPresenter := OPModelTypeSelector on: projectController.
	selectorPresenter instVarNamed: #pluginRegistry put: pluginRegistry.
	selectorPresenter connectPresenters.

	nameInput := selectorPresenter instVarNamed: #projectNameInput.
	pluginsList := selectorPresenter instVarNamed: #plugins.

	self assert: nameInput text equals: 'New Secondary Test Plugin Model'.
	pluginsList selectItem: plugin1.
	self assert: nameInput text equals: 'New Test Plugin Model'.

	nameInput text: 'Custom preserved name'.
	pluginsList selectItem: plugin2.
	self assert: nameInput text equals: 'Custom preserved name'.

	pluginsList unselectAll.
	(selectorPresenter stub inform: Any) willReturn: selectorPresenter.
	selectorPresenter addModel.
	selectorPresenter should receive inform: 'Select type of the model first'.
	self assertEmpty: project diagrams.

	pluginsList selectItem: plugin1.
	window := selectorPresenter open.
	[
		self assert: window title equals: 'OpenPonk - Add new model to project'.
		self assert: window initialExtent equals: 300 @ 265.
		selectorPresenter addModel.
		self assert: project diagrams size equals: 1.
		self assert: project diagrams first modelElement class identicalTo: OPTestContainerModel.
		self assert: project diagrams first modelElement name equals: 'Custom preserved name'.
		workbench should receive openEditorOnDiagram: project diagrams first
	] ensure: [ window close ]
]
