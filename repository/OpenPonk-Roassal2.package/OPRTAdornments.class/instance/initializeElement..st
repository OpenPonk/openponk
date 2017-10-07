initialization
initializeElement: anElement
	anElement when: OPTRFocused do: [ :e | self showAdornmentsOn: anElement ].
	anElement when: OPTRUnfocused do: [ :e | self hideAdornmentsOn: anElement ]