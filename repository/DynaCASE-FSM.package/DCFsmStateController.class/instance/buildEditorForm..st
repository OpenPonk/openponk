hooks
buildEditorForm: aForm
	super buildEditorForm: aForm.

	(aForm addCheckbox: 'Final')
		state: self model isFinal;
		whenChangedDo: [ :newValue | self model isFinal: newValue ]