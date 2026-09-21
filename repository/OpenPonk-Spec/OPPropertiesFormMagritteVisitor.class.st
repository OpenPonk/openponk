"
Magritte visitor that traverses Magritte descriptions and translates them into corresponding UI widgets within an OPDynamicForm.
"
Class {
	#name : 'OPPropertiesFormMagritteVisitor',
	#superclass : 'MAVisitor',
	#instVars : [
		'form',
		'viewModel'
	],
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'accessing - compatibility' }
OPPropertiesFormMagritteVisitor >> controller [
	self deprecated: 'Use viewModel instead'.
	^ self viewModel
]

{ #category : 'accessing - compatibility' }
OPPropertiesFormMagritteVisitor >> controller: anObject [
	self deprecated: 'Use viewModel: instead'.
	self viewModel: anObject asViewModel
]

{ #category : 'accessing' }
OPPropertiesFormMagritteVisitor >> form [
	^ form
]

{ #category : 'accessing' }
OPPropertiesFormMagritteVisitor >> form: anObject [
	form := anObject
]

{ #category : 'testing' }
OPPropertiesFormMagritteVisitor >> shouldIncludeLabelFor: aContainer [
	"container priority = 0 is the root container"

	^ aContainer priority > 0 & aContainer label isNotNil
]

{ #category : 'accessing' }
OPPropertiesFormMagritteVisitor >> target [
	^ self viewModel
]

{ #category : 'accessing' }
OPPropertiesFormMagritteVisitor >> target: aTarget [
	self viewModel: aTarget asViewModel
]

{ #category : 'accessing' }
OPPropertiesFormMagritteVisitor >> viewModel [
	^ viewModel
]

{ #category : 'accessing' }
OPPropertiesFormMagritteVisitor >> viewModel: aViewModel [
	viewModel := aViewModel
]

{ #category : 'visiting' }
OPPropertiesFormMagritteVisitor >> visit: anObject [
	((anObject respondsTo: #isVisible) and: [ anObject isVisible not ])
		ifTrue: [ ^ self ].
	^ super visit: anObject
]

{ #category : 'visiting' }
OPPropertiesFormMagritteVisitor >> visitActionDescription: aDescription [
	(form addButton: aDescription label) action: aDescription action
]

{ #category : 'visiting-description' }
OPPropertiesFormMagritteVisitor >> visitBooleanDescription: aBooleanDescription [
	form
		bindCheckbox: aBooleanDescription label
		accessor: aBooleanDescription accessor
		description: aBooleanDescription
]

{ #category : 'visiting' }
OPPropertiesFormMagritteVisitor >> visitLabelDescription: aStringDescription [

	form addHeadingLabel: aStringDescription label.
	form addLabel: (aStringDescription accessor read: self viewModel)
]

{ #category : 'visiting-description' }
OPPropertiesFormMagritteVisitor >> visitMemoDescription: aMemoDescription [
	| isLong |
	isLong := aMemoDescription lineCount > aMemoDescription class defaultLineCount.
	isLong
		ifTrue: [
			form
				bindLongText: aMemoDescription label
				accessor: aMemoDescription accessor
				description: aMemoDescription ]
		ifFalse: [
			form
				bindText: aMemoDescription label
				accessor: aMemoDescription accessor
				description: aMemoDescription ]
]

{ #category : 'visiting-description' }
OPPropertiesFormMagritteVisitor >> visitMultipleOptionDescription: aMultipleOptionDescription [

	| dropList |
	aMultipleOptionDescription isExtensible ifTrue: [
			self notify: 'Extensibility of multilists not yet supported'.
			^ self ].
	dropList := form addList: aMultipleOptionDescription label.
	dropList
		beMultipleSelection;
		items: aMultipleOptionDescription options;
		enabled: aMultipleOptionDescription isReadOnly not;
		display: [ :each | aMultipleOptionDescription labelForOption: each ];
		displayIcon: [ :each :item | aMultipleOptionDescription iconForOption: each ];
		selectItems: (aMultipleOptionDescription accessor read: self viewModel);
		whenSelectionChangedDo: [ :selection | aMultipleOptionDescription accessor write: selection selectedItems to: self viewModel ]
]

{ #category : 'visiting-description' }
OPPropertiesFormMagritteVisitor >> visitPriorityContainer: aContainer [
	(self shouldIncludeLabelFor: aContainer)
		ifTrue: [ form addHeadingLabel: aContainer label ].
	aContainer children do: [ :each | self visit: each ].
	form addSeparator
]

{ #category : 'visiting-description' }
OPPropertiesFormMagritteVisitor >> visitSingleOptionDescription: aSingleOptionDescription [
	form
		bindDroplist: aSingleOptionDescription label
		accessor: aSingleOptionDescription accessor
		description: aSingleOptionDescription
		configuration: [ :dropList |
			dropList
				items: aSingleOptionDescription options;
				enabled: aSingleOptionDescription isReadOnly not;
				display: [ :each | aSingleOptionDescription labelForOption: each ];
				displayIcon: [ :each :item | aSingleOptionDescription iconForOption: each ] ]
]

{ #category : 'visiting-description' }
OPPropertiesFormMagritteVisitor >> visitStringDescription: aStringDescription [
	aStringDescription isReadOnly ifTrue: [
		^ self visitLabelDescription: aStringDescription ].
	form
		bindTextInput: aStringDescription label
		accessor: aStringDescription accessor
		description: aStringDescription
]

{ #category : 'visiting-description' }
OPPropertiesFormMagritteVisitor >> visitToManyRelationDescription: aToManyRelationDescription [

	| label hasDisplay |
	label := aToManyRelationDescription label.
	form addHeadingLabel: label.
	hasDisplay := aToManyRelationDescription displayBlockOrSymbol ~= aToManyRelationDescription class defaultDisplayProperty.
	hasDisplay ifTrue: [
			(aToManyRelationDescription accessor read: self viewModel) do: [ :eachModel |
				form addLabel: (aToManyRelationDescription displayStringFor: eachModel) ] ].
	(form addButton: 'Edit ' , (label ifNil: [ '' ])) action: [
		self viewModel openEditorWithApplication: form application undoManager: form undoManager ]
]
