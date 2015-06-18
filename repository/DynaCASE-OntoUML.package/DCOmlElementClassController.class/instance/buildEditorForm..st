hooks
buildEditorForm: aForm
	super buildEditorForm: aForm.

	(aForm addText: 'Attributes')
		text: self model attributes asStringWithCr;
		whenTextIsAccepted: [ :newValue | self updateAttributesFrom: newValue ].

	(aForm addText: 'Methods')
		text: self model methods asStringWithCr;
		whenTextIsAccepted: [ :newValue | self updateMethodsFrom: newValue ]