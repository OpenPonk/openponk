"
Verifies model type selection presenter initialization, automatic naming, button enablement, and adding a new model to a project.
"
Class {
	#name : 'OPModelTypeSelectorTest',
	#superclass : 'TestCase',
	#instVars : [
		'selectorPresenter'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
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
