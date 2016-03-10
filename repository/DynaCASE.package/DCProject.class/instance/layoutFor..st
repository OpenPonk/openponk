accessing
layoutFor: aDiagram
	^ layouts at: aDiagram uuid asString ifAbsent: [ Dictionary new ]