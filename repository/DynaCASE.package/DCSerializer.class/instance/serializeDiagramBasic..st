serializing
serializeDiagramBasic: aDiagram
	| d |
	d := Dictionary new.
	d at: #name put: aDiagram name.
	d at: #className put: aDiagram class asString.
	d at: #dcID put: aDiagram dcID.
	^ d