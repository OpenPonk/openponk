instance creation
pragmaMultiKeyword: aPragmaKeyword model: aModel
	"Build a builder using aPragmaKeyword and aPragmaKeyword: as the pragma keywords and aModel a the model of the resulting builder"

	^ self
		withAllPragmaKeywords: (Array with: aPragmaKeyword with: (aPragmaKeyword , ':') asSymbol)
		model: aModel