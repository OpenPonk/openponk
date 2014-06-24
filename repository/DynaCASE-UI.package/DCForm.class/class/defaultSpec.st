specs
defaultSpec
	| textFieldHeight |
	textFieldHeight := StandardFonts defaultFont height + 3.
	^ SpecLayout composed
		add: #nameField
			origin: 0 @ 0
			corner: 1 @ 0
			offsetOrigin: 0 @ 0
			offsetCorner: 0 @ textFieldHeight;
		yourself