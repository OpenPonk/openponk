hooks
buildEditorForm: aForm
	super buildEditorForm: aForm.

	(aForm addText: 'Attributes')
		text: (self joinProps: self model attributes);
		whenTextIsAccepted: [ :newValue | self updateAttributesFrom: newValue ].

	(aForm addText: 'Methods')
		text: (self joinProps: self model methods);
		whenTextIsAccepted: [ :newValue | self updateMethodsFrom: newValue ]