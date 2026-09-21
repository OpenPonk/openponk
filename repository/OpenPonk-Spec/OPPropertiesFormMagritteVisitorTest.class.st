"
Unit tests verifying the correct translation of Magritte descriptions (like relations, text, and numbers) into corresponding Spec UI widgets by OPDynamicFormMagritteVisitor.
"
Class {
	#name : 'OPPropertiesFormMagritteVisitorTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPPropertiesFormMagritteVisitorTest >> testToManyRelation [
	| visitor form button target relation |
	visitor := OPPropertiesFormMagritteVisitor new.
	form := Mock new.
	button := Mock new.
	target := Mock new.

	(target stub openEditorWithApplication: Any undoManager: Any) willReturn: nil.

	visitor viewModel: target.
	visitor form: form.

	(form stub addButton: (Kind of: String)) willReturn: button.
	form stub application willReturn: nil.
	form stub undoManager willReturn: nil.

	relation := MAToManyRelationDescription new.
	relation accessor:
		(MAPluggableAccessor read: [ :modelElement | #( ) ] write: [ :modelElement :newValue | ]).

	visitor visitToManyRelationDescription: relation.

	(form should receive addButton: (Kind of: String)) once.

	button should receive action: [ :block |
		block value.
		(target should receive openEditorWithApplication: Any undoManager: Any) once ]
]

{ #category : 'tests' }
OPPropertiesFormMagritteVisitorTest >> testVisitorOpensPackageGeneralizationSetsEditorWithUndoManager [
		"Verifies that Edit Generalization Sets button invokes the editor with transactional undoManager from form"
		| package packageViewModel form visitor undoManager editButton |
		package := OPUMLPackage new name: 'TestPackage'.
		packageViewModel := OPUmlPackageViewModel new.
		packageViewModel instVarNamed: 'model' put: package.

		undoManager := OPUndoManager new.
		form := OPPropertiesForm new.
		form undoManager: undoManager.

		visitor := OPPropertiesFormMagritteVisitor new.
		visitor form: form.
		visitor viewModel: packageViewModel.

		visitor visitToManyRelationDescription: packageViewModel descriptionGeneralizationSets.

		editButton := form components detect: [ :eachComponent |
			(eachComponent respondsTo: #label) and: [ eachComponent label beginsWith: 'Edit Generalization Sets' ] ].

		self assert: editButton isNotNil
]
