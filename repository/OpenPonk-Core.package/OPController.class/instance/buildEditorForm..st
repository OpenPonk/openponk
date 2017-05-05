forms
buildEditorForm: aForm
	(aForm addTextInput: 'Name')
		text: self model name;
		whenTextIsAccepted: [ :newValue | self model name: newValue ]