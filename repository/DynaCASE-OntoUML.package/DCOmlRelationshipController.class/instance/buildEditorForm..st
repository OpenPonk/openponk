hooks
buildEditorForm: aForm
	super buildEditorForm: aForm.

	(aForm addTextInput: 'Start Multiplicity')
		text: self model startMultiplicity;
		whenTextIsAccepted: [ :newValue | 
					self model startMultiplicity: newValue.
					self model changed ].

	(aForm addTextInput: 'End Multiplicity')
		text: self model endMultiplicity;
		whenTextIsAccepted: [ :newValue | 
					self model endMultiplicity: newValue.
					self model changed ]