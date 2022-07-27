"
I convert magritte descriptions into DynamicForm widgets.
"
Class {
	#name : #OPDynamicFormMagritteVisitor,
	#superclass : #MAVisitor,
	#instVars : [
		'form',
		'controller'
	],
	#category : #'OpenPonk-Spec-Form'
}

{ #category : #accessing }
OPDynamicFormMagritteVisitor >> controller [
	^ controller
]

{ #category : #accessing }
OPDynamicFormMagritteVisitor >> controller: anObject [
	controller := anObject
]

{ #category : #accessing }
OPDynamicFormMagritteVisitor >> form [
	^ form
]

{ #category : #accessing }
OPDynamicFormMagritteVisitor >> form: anObject [
	form := anObject
]

{ #category : #testing }
OPDynamicFormMagritteVisitor >> shouldIncludeLabelFor: aContainer [
	"container priority = 0 is the root container"

	^ aContainer priority > 0 & aContainer label isNotNil
]

{ #category : #visiting }
OPDynamicFormMagritteVisitor >> visit: anObject [
	((anObject respondsTo: #isVisible) and: [ anObject isVisible not ])
		ifTrue: [ ^ self ].
	^ super visit: anObject
]

{ #category : #visiting }
OPDynamicFormMagritteVisitor >> visitActionDescription: aDescription [
	(form addButton: aDescription label) action: aDescription action
]

{ #category : #visiting }
OPDynamicFormMagritteVisitor >> visitBooleanDescription: aBooleanDescription [
	(form addCheckbox: aBooleanDescription label)
		state: (aBooleanDescription accessor read: controller);
		whenChangedDo: [ :newValue | aBooleanDescription accessor write: newValue to: controller ];
		in:
				[ :input | aBooleanDescription accessor opWhenUpdated: [ :newValue | input state: newValue ] ]
]

{ #category : #visiting }
OPDynamicFormMagritteVisitor >> visitLabelDescription: aStringDescription [

	form addLabel: aStringDescription label.
	form addLabel: (aStringDescription accessor read: controller)
]

{ #category : #visiting }
OPDynamicFormMagritteVisitor >> visitMemoDescription: aMemoDescription [

	(form addText: aMemoDescription label)
		text: (aMemoDescription accessor read: controller);
		whenTextChangedDo: [ :newValue | 
			aMemoDescription accessor write: newValue asString to: controller ]
]

{ #category : #visiting }
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
		selectItems: (aMultipleOptionDescription accessor read: controller);
		whenSelectionChangedDo: [ :selection | 
			selection accessor write: selection selectedItems to: controller ]
]

{ #category : #visiting }
OPDynamicFormMagritteVisitor >> visitPriorityContainer: aContainer [
	(self shouldIncludeLabelFor: aContainer)
		ifTrue: [ form addLabel: aContainer label ].
	aContainer children do: [ :each | self visit: each ].
	form addSeparator
]

{ #category : #visiting }
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
			(aSingleOptionDescription accessor read: controller)
		do: [  ];
		whenSelectedItemChangedDo: [ :newValue | 
			aSingleOptionDescription accessor write: newValue to: controller ]
]

{ #category : #visiting }
OPDynamicFormMagritteVisitor >> visitStringDescription: aStringDescription [

	aStringDescription isReadOnly ifTrue: [ 
		^ self visitLabelDescription: aStringDescription ].
	(form addTextInput: aStringDescription label)
		text: ((aStringDescription accessor read: controller) ifNil: [ '' ]);
		whenTextChangedDo: [ :newText | 
			[ 
			| newString |
			newString := newText asString.
			aStringDescription validate: newString.
			aStringDescription accessor write: newString to: controller ]
				on: MAValidationError
				do: [ :e | 
					OPWorkbench isDevelopmentMode
						ifTrue: [ e pass ]
						ifFalse: [ 
							(GrowlMorph label: 'Error' contents: e asString)
								backgroundColor: GrowlMorph theme dangerBackgroundColor;
								openInWorld ] ] ];
		in: [ :input | 
			aStringDescription accessor opWhenUpdated: [ :newValue | 
				input text: newValue ] ]
]

{ #category : #visiting }
OPDynamicFormMagritteVisitor >> visitToManyRelationDescription: aMAToManyRelationDescription [
	form addLabel: aMAToManyRelationDescription label.
	(form addButton: 'Edit ') action: [ controller maEdit ]
]
