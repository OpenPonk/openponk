initialization
initialize
	self
		canvas: TRCanvas new;
		format: #png;
		fileName: [ ('export.' , format) asSymbol ];
		oversizedBy: 0 @ 0