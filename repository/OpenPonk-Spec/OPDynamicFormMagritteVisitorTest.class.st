"
Unit tests verifying the correct translation of Magritte descriptions (like relations, text, and numbers) into corresponding Spec UI widgets by OPDynamicFormMagritteVisitor.
"
Class {
	#name : 'OPDynamicFormMagritteVisitorTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPDynamicFormMagritteVisitorTest >> testToManyRelation [

	| visitor form button target relation |
	visitor := OPDynamicFormMagritteVisitor new.
	form := Mock new.
	button := Mock new.
	target := Mock new.

	target stub maEdit willReturn: nil.

	visitor controller: target.
	visitor form: form.

	(form stub addButton: (Kind of: String)) willReturn: button.

	relation := MAToManyRelationDescription new.
	relation accessor:
		(MAPluggableAccessor read: [ :m | #(  ) ] write: [ :m :v |  ]).

	visitor visitToManyRelationDescription: relation.

	(form should receive addButton: (Kind of: String)) once.

	button should receive action: [ :block |
			block value.
			target should receive maEdit ]
]
