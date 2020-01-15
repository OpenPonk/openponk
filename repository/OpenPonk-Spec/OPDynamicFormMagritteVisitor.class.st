"
I convert magritte descriptions into DynamicForm widgets.
"
Class {
	#name : #OPDynamicFormMagritteVisitor,
	#superclass : #Object,
	#instVars : [
		'form',
		'controller'
	],
	#category : 'OpenPonk-Spec-Form'
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
	anObject isVisible
		ifFalse: [ ^ self ].
	anObject acceptMagritte: self
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
	(form addLabel: (aStringDescription accessor read: controller)) emphasis: #()
]

{ #category : #visiting }
OPDynamicFormMagritteVisitor >> visitMemoDescription: aMemoDescription [
	(form addText: aMemoDescription label)
		text: (aMemoDescription accessor read: controller);
		whenTextIsAccepted: [ :newValue | aMemoDescription accessor write: newValue asString to: controller ]
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
	(aSingleOptionDescription isExtensible
		ifTrue: [ form addEditableDroplist: aSingleOptionDescription label ]
		ifFalse: [ form addDroplist: aSingleOptionDescription label ])
		items: aSingleOptionDescription options;
		enabled: aSingleOptionDescription isReadonly not;
		displayBlock: [ :each | aSingleOptionDescription labelForOption: each ];
		iconHolder: [ :each :item | aSingleOptionDescription iconForOption: each ];
		setSelectedItem: (aSingleOptionDescription accessor read: controller);
		whenSelectedItemChanged: [ :newValue | aSingleOptionDescription accessor write: newValue to: controller ]
]

{ #category : #visiting }
OPDynamicFormMagritteVisitor >> visitStringDescription: aStringDescription [
	aStringDescription isReadonly
		ifTrue: [ ^ self visitLabelDescription: aStringDescription ].
	(form addTextInput: aStringDescription label)
		text: (aStringDescription accessor read: controller);
		whenTextIsAccepted: [ :newValue | 
			[ aStringDescription validate: newValue.
			aStringDescription accessor write: newValue to: controller ]
				on: MAValidationError
				do: [ :e | self inform: e messageText ] ];
		in: [ :input | aStringDescription accessor opWhenUpdated: [ :newValue | input text: newValue ] ]
]

{ #category : #visiting }
OPDynamicFormMagritteVisitor >> visitToManyRelationDescription: aMAToManyRelationDescription [
	form addLabel: aMAToManyRelationDescription label.
	(form addButton: 'Edit ') action: [ controller maEdit ]
]
