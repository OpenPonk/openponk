hooks
buildEditorForm: aForm
	super buildEditorForm: aForm.
	(aForm addTextInput: 'Source name')
		text: self model sourceName;
		whenTextIsAccepted: [ :newValue | self model sourceName: newValue ].
	(aForm addTextInput: 'Target name')
		text: self model targetName;
		whenTextIsAccepted: [ :newValue | self model targetName: newValue ]