initialization
newCollectorForKeyword: aKeyword
	^ (PragmaCollector
		filter: [ :prg | prg keyword = aKeyword and: [ prg methodSelector numArgs = 1 ] ])
		reset;
		yourself