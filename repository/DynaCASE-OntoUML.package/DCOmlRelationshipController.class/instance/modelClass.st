accessing
modelClass
	| matcher |
	matcher := 'DCOml(.*)Controller' asRegex.
	matcher matches: self class asString.
	^ (matcher subexpression: 2) asClass