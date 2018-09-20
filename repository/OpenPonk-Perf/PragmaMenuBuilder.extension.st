Extension { #name : #PragmaMenuBuilder }

{ #category : #'*OpenPonk-Perf' }
PragmaMenuBuilder class >> cachedPragmaKeyword: aPragmaKeyword model: aModel [
	"Build a builder using aPragmaKeyword as the pragma keyword and aModel a the model of the resulting builder"

	^ (self withAllPragmaKeywords: (Array with: aPragmaKeyword) model: aModel)
		pragmaCollector: (OPPragmaCache current collectorForKeyword: aPragmaKeyword);
		yourself
]

{ #category : #'*OpenPonk-Perf' }
PragmaMenuBuilder >> pragmaCollector: aCollector [
	self assert: [ pragmaCollector isNil ] description: 'Pragma Collector cannot be changed.'.
	pragmaCollector := aCollector.
"	pragmaCollector whenChangedSend: #reset to: self"
]
