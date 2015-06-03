hooks
buildEditorForm: aForm
	super buildEditorForm: aForm.

	(aForm addText: 'Attributes')
		text: self model attributes asStringWithCr;
		whenTextIsAccepted: [ :newValue | self parseAttributes: newValue ].

	(aForm addText: 'Methods')
		text: self model methods asStringWithCr;
		whenTextIsAccepted: [ :newValue | self parseMethods: newValue ]