protocol
remove
	(feedback attributes includesKey: self originalColorSymbol)
		ifFalse: [ ^ self ].
	feedback shape color: (feedback attributes at: self originalColorSymbol).
	feedback attributes removeKey: self originalColorSymbol.
	feedback update.
	feedback view signalUpdate