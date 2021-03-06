Class {
	#name : #OPModelTypeSelector,
	#superclass : #SpPresenter,
	#instVars : [
		'projectController',
		'addModelButton',
		'pluginRegistry',
		'radioButtons',
		'radioButtonsPerPlugin',
		'projectNameInput'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPModelTypeSelector class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: SpBoxLayout newHorizontal;
		add: #radioButtons;
		add: SpBoxLayout newHorizontal;
		add: #projectNameInput expand: false fill: false padding: 5;
		add: #addModelButton height: self buttonHeight;
		yourself
]

{ #category : #'as yet unclassified' }
OPModelTypeSelector >> addModel [
	| model diagram plugin |
	plugin := (radioButtonsPerPlugin associations
		detect: [ :pluginAndRadioButton | pluginAndRadioButton value state ]
		ifNone: [ ^ self ]) key.
	model := plugin newModel
		name: projectNameInput text;
		yourself.
	diagram := OPDiagram withWholeModel: model.
	projectController project
		addModel: model;
		addDiagram: diagram.
	projectController openEditorOnDiagram: diagram.
	self withWindowDo: #close
]

{ #category : #'accessing - spec' }
OPModelTypeSelector >> addModelButton [
	^ addModelButton
]

{ #category : #initialization }
OPModelTypeSelector >> connectPresenters [
	| builder |
	addModelButton action: [ self addModel ].
	projectNameInput
		autoAccept: true;
		whenTextChangedDo: [ :newValue | addModelButton enabled: newValue isNotEmpty ].
	builder := SpDynamicPresentersListBuilder new
		modelObjects: pluginRegistry plugins;
		presenter: SpRadioButtonPresenter
			configuredAs: [ :radioButtonPresenter :plugin | 
			radioButtonsPerPlugin size > 1
				ifTrue: [ radioButtonPresenter
						associatedRadioButtons: radioButtonsPerPlugin values ].
			radioButtonsPerPlugin at: plugin put: radioButtonPresenter.
			radioButtonPresenter label: plugin name ];
		layoutBuilder: (SpDynamicTopToBottomRowsLayout rows: 1);
		yourself.
	self newDynamicPresentersListIn: #radioButtons usingBuilder: builder
]

{ #category : #api }
OPModelTypeSelector >> initialExtent [
	^ 400 @ 300
]

{ #category : #initialization }
OPModelTypeSelector >> initialize [
	radioButtonsPerPlugin := Dictionary new.
	pluginRegistry := OPPluginRegistry default.
	super initialize
]

{ #category : #initialization }
OPModelTypeSelector >> initializePresenters [
	radioButtons := self newNullPresenter.
	projectNameInput := self newTextInput text: 'New Model'.
	addModelButton := self newButton label: 'Create'
]

{ #category : #accessing }
OPModelTypeSelector >> radioButtons [
	^ radioButtons
]

{ #category : #accessing }
OPModelTypeSelector >> radioButtons: aDynamicPresenter [
	radioButtons := aDynamicPresenter
]

{ #category : #'accessing model' }
OPModelTypeSelector >> setModelBeforeInitialization: aProjectController [
	projectController := aProjectController
]

{ #category : #'accessing - spec' }
OPModelTypeSelector >> title [
	^ 'Select new model to OpenPonk project'
]
