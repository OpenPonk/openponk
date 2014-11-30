accessing
layoutFor: aDiagram
	^ layouts at: aDiagram dcID ifAbsent: [ nil ]