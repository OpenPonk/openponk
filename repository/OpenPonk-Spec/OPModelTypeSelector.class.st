Class {
	#name : #OPModelTypeSelector,
	#superclass : #SpPresenter,
	#instVars : [
		'projectController',
		'addModelButton',
		'pluginRegistry',
		'plugins',
		'projectNameInput',
		'projectNameLabel',
		'pluginsLabel',
		'nameChanged'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #'as yet unclassified' }
OPModelTypeSelector class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #pluginsLabel
		  expand: false
		  fill: false
		  padding: 5;
		  add: #plugins;
		  add: (SpBoxLayout newLeftToRight
				   add: #projectNameLabel
				   expand: false
				   fill: false
				   padding: 2;
				   add: #projectNameInput;
				   yourself)
		  expand: false
		  fill: false
		  padding: 5;
		  add: (SpBoxLayout newLeftToRight
				   add: SpBoxLayout newTopToBottom;
				   add: #addModelButton width: 150;
				   add: SpBoxLayout newTopToBottom;
				   yourself)
		  height: self buttonHeight;
		  yourself
]

{ #category : #'as yet unclassified' }
OPModelTypeSelector >> addModel [

	| model diagram selectedPlugin |
	selectedPlugin := plugins selectedItem.
	selectedPlugin ifNil: [ 
		^ self inform: 'Select type of the model first' ].
	model := selectedPlugin newModel
		         name: projectNameInput text;
		         yourself.
	diagram := OPOpenPonkDiagram forModelElement: model.
	projectController project addDiagram: diagram.
	projectController openEditorOnDiagram: diagram.
	self withWindowDo: #close
]

{ #category : #initialization }
OPModelTypeSelector >> connectPresenters [

	addModelButton action: [ self addModel ].
	projectNameInput whenTextChangedDo: [ :newValue | 
		nameChanged := true.
		self ensureButtonActivation ].
	plugins items: pluginRegistry plugins.
	plugins whenSelectionChangedDo: [ :selection | 
		self ensureButtonActivation.
		selection selectedItem ifNotNil: [ :selectedItem | 
			nameChanged ifFalse: [ 
				projectNameInput text: 'New ' , selectedItem name , ' Model'.
				nameChanged := false ] ] ].
	plugins items ifNotEmpty: [ plugins selectFirst ]
]

{ #category : #initialization }
OPModelTypeSelector >> ensureButtonActivation [

	addModelButton enabled: (projectNameInput text isNotEmpty and: [ 
			 plugins selectedItem isNotNil ])
]

{ #category : #initialization }
OPModelTypeSelector >> initialize [

	pluginRegistry := OPPluginRegistry default.
	nameChanged := false.
	super initialize
]

{ #category : #initialization }
OPModelTypeSelector >> initializePresenters [

	pluginsLabel := self newLabel label: 'Select model type:'.
	plugins := self newList.
	plugins display: [ :plugin | plugin name ].
	projectNameLabel := self newLabel label: 'Model name: '.
	projectNameInput := self newTextInput text: 'New Model'.
	addModelButton := self newButton label: 'Create'
]

{ #category : #initialization }
OPModelTypeSelector >> initializeWindow: aWindow [
	aWindow
		title: 'OpenPonk - Add new model to project';
		initialExtent: 300 @ 265;
		windowIcon: OPCoreIcons openponkIcon
]

{ #category : #'accessing model' }
OPModelTypeSelector >> setModelBeforeInitialization: aProjectController [
	projectController := aProjectController
]
