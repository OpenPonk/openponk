Class {
	#name : #OPDynamicFormMagritteVisitorTest,
	#superclass : #TestCase,
	#category : #'OpenPonk-Spec-Tests'
}

{ #category : #tests }
OPDynamicFormMagritteVisitorTest >> testToManyRelation [
	| visitor form button controller morph |
	visitor := OPDynamicFormMagritteVisitor new.
	form := Mock new.
	button := Mock new.
	controller := OPElementController new model: Mock new.
	morph := Mock new.
	controller stub asMagritteMorph willReturn: morph.
	visitor controller: controller.
	(form stub addButton: (Kind of: String)) willReturn: button.
	visitor form: form.
	visitor
		visitToManyRelationDescription: MAToManyRelationDescription new.
	(form should receive addButton: (Kind of: String)) once.
	button should receive action: (Kind of: BlockClosure).
	button should receive
		action: [ :block | 
			block value.
			morph should receive openInWorld ]
]
