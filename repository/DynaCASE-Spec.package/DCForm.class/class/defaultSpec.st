specs
defaultSpec
	| nameFieldHeight |
	nameFieldHeight := StandardFonts defaultFont height + 3.
	^ SpecLayout composed
		add: #nameField
			origin: 0 @ 0
			corner: 1 @ 0
			offsetOrigin: 0 @ 0
			offsetCorner: 0 @ nameFieldHeight;
		add: #textField
			origin: 0 @ 0
			corner: 1 @ 1
			offsetOrigin: 0 @ nameFieldHeight
			offsetCorner: 0 @ nameFieldHeight * -2;
		yourself