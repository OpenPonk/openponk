initialization
initialize
	self
		format: #png;
		fileName: [ ('export.' , format) asSymbol ];
		oversizedBy: 0 @ 0