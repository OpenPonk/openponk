initialization
initialize
	self asPNG
		fileName: [ 'export.' , format ];
		oversizedBy: 0 @ 0.
	finalized := false.
	margin := 0 @ 0