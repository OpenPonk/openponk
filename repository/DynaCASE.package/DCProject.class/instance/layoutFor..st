accessing
layoutFor: aDiagram
	^ layouts at: aDiagram dcID asString ifAbsent: [ nil ]