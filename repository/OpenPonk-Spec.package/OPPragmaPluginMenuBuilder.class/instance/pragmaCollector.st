registrations handling
pragmaCollector
	"Return an up-to-date pragmaCollector which contains all pragmas which keyword is 'pragmaKeyword' or 'pragmaKeyword:'"

	^ pragmaCollector
		ifNil: [ pragmaCollector := PragmaCollector
				filter: [ :prg | (self isWantedPragma: prg) and: [ self hasCorrectArguments: prg ] ].
			(self pragmaKeywords notNil and: [ self pragmaKeywords notEmpty ])
				ifTrue: [ pragmaCollector reset ].
			pragmaCollector whenChangedSend: #reset to: self.
			pragmaCollector ]