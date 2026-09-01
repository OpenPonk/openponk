"
Magritte visitor that traverses Magritte descriptions and translates them into corresponding UI widgets within an OPDynamicForm.
"
Class {
	#name : 'OPDynamicFormMagritteVisitor',
	#superclass : 'MAVisitor',
	#instVars : [
		'form',
		'controller'
	],
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'accessing' }
OPDynamicFormMagritteVisitor >> controller [
	^ controller
]

{ #category : 'accessing' }
OPDynamicFormMagritteVisitor >> controller: anObject [
	controller := anObject
]

{ #category : 'accessing' }
OPDynamicFormMagritteVisitor >> form [
	^ form
]

{ #category : 'accessing' }
OPDynamicFormMagritteVisitor >> form: anObject [
	form := anObject
]

{ #category : 'testing' }
OPDynamicFormMagritteVisitor >> shouldIncludeLabelFor: aContainer [
	"container priority = 0 is the root container"

	^ aContainer priority > 0 & aContainer label isNotNil
]

{ #category : 'accessing' }
OPDynamicFormMagritteVisitor >> target [
	^ controller
]

{ #category : 'accessing' }
OPDynamicFormMagritteVisitor >> target: anObject [
	controller := anObject
]

{ #category : 'visiting' }
OPDynamicFormMagritteVisitor >> visit: anObject [
	((anObject respondsTo: #isVisible) and: [ anObject isVisible not ])
		ifTrue: [ ^ self ].
	^ super visit: anObject
]

{ #category : 'visiting' }
OPDynamicFormMagritteVisitor >> visitActionDescription: aDescription [
	(form addButton: aDescription label) action: aDescription action
]

{ #category : 'visiting-description' }
OPDynamicFormMagritteVisitor >> visitBooleanDescription: aBooleanDescription [

	(form addCheckbox: aBooleanDescription label)
		state: (aBooleanDescription accessor read: self target);
		whenChangedDo: [ :newValue |
			aBooleanDescription accessor write: newValue to: self target ]
]

{ #category : 'visiting' }
OPDynamicFormMagritteVisitor >> visitLabelDescription: aStringDescription [

	form addHeadingLabel: aStringDescription label.
	form addLabel: (aStringDescription accessor read: self target)
]

{ #category : 'visiting-description' }
OPDynamicFormMagritteVisitor >> visitMemoDescription: aMemoDescription [

	(aMemoDescription lineCount > aMemoDescription class defaultLineCount
		 ifTrue: [ form addLongText: aMemoDescription label ]
		 ifFalse: [ form addText: aMemoDescription label ])
		text: (aMemoDescription accessor read: self target);
		whenTextChangedDo: [ :newValue | 
			aMemoDescription accessor write: newValue asString to: self target ]
]

{ #category : 'visiting-description' }
OPDynamicFormMagritteVisitor >> visitMultipleOptionDescription: aMultipleOptionDescription [

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
		displayIcon: [ :each :item |
			aMultipleOptionDescription iconForOption: each ];
		selectItems: (aMultipleOptionDescription accessor read: self target);
		whenSelectionChangedDo: [ :selection |
			aMultipleOptionDescription accessor write: selection selectedItems to: self target ]
]

{ #category : 'visiting-description' }
OPDynamicFormMagritteVisitor >> visitPriorityContainer: aContainer [
	(self shouldIncludeLabelFor: aContainer)
		ifTrue: [ form addHeadingLabel: aContainer label ].
	aContainer children do: [ :each | self visit: each ].
	form addSeparator
]

{ #category : 'visiting-description' }
OPDynamicFormMagritteVisitor >> visitSingleOptionDescription: aSingleOptionDescription [

	| dropList |
	dropList := aSingleOptionDescription isExtensible
		            ifTrue: [ 
		            form addEditableDroplist: aSingleOptionDescription label ]
		            ifFalse: [ 
		            form addDroplist: aSingleOptionDescription label ].
	dropList
		items: aSingleOptionDescription options;
		enabled: aSingleOptionDescription isReadOnly not;
		display: [ :each | aSingleOptionDescription labelForOption: each ];
		displayIcon: [ :each :item | 
			aSingleOptionDescription iconForOption: each ];
		addAndSelectItemLabeled:
			(aSingleOptionDescription accessor read: self target)
		do: [  ];
		whenSelectedItemChangedDo: [ :newValue | 
			aSingleOptionDescription accessor write: newValue to: self target ]
]

{ #category : 'visiting-description' }
OPDynamicFormMagritteVisitor >> visitStringDescription: aStringDescription [

	aStringDescription isReadOnly ifTrue: [
		^ self visitLabelDescription: aStringDescription ].
	(form addTextInput: aStringDescription label)
		text:
			((aStringDescription accessor read: self target) ifNil: [ '' ]);
		whenTextChangedDo: [ :newText |
				[
					| newString |
					newString := newText asString.
					aStringDescription validate: newString.
					aStringDescription accessor write: newString to: self target ]
					on: MAValidationError
					do: [ :e |
							OPWorkbench isDevelopmentMode
								ifTrue: [ e pass ]
								ifFalse: [
										(GrowlMorph label: 'Error' contents: e asString)
											backgroundColor: GrowlMorph theme dangerBackgroundColor;
											openInWorld ] ] ]
]

{ #category : 'visiting-description' }
OPDynamicFormMagritteVisitor >> visitToManyRelationDescription: aMAToManyRelationDescription [

	| label hasDisplay |
	label := aMAToManyRelationDescription label.
	form addHeadingLabel: label.
	hasDisplay := aMAToManyRelationDescription displayBlockOrSymbol
	              ~=
	              aMAToManyRelationDescription class
		              defaultDisplayProperty.
	hasDisplay ifTrue: [
		(aMAToManyRelationDescription accessor read: self target) do: [ :each |
			form addLabel:
				(aMAToManyRelationDescription displayStringFor: each) ] ].
	(form addButton: 'Edit ' , (label ifNil: [ '' ])) action: [
		controller maEdit ]
]
