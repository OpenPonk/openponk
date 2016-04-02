adding
hasDiagram: aDiagram
	^ controllers anySatisfy: [ :each | each model = aDiagram ]