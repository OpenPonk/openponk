hooks
buildEditorForm: aForm
	super buildEditorForm: aForm.

	(aForm addCheckbox: 'Shareable')
		state: self model isShareable;
		whenChangedDo: [ :newValue | self model shareable: newValue ].

	(aForm addCheckbox: 'Essential')
		state: self model isEssential;
		whenChangedDo: [ :newValue | self model essential: newValue ].

	(aForm addCheckbox: 'Inseparable')
		state: self model isInseparable;
		whenChangedDo: [ :newValue | self model inseparable: newValue ].

	(aForm addCheckbox: 'Immutable Part')
		state: self model isImmutablePart;
		whenChangedDo: [ :newValue | self model immutablePart: newValue ].

	(aForm addCheckbox: 'Immutable Whole')
		state: self model isImmutableWhole;
		whenChangedDo: [ :newValue | self model immutableWhole: newValue ]