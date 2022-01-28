Extension { #name : #OPPragmaPluginMenuBuilder }

{ #category : #'*OpenPonk-Pharo8OPExtensions' }
OPPragmaPluginMenuBuilder >> pragmas [
	"Return all pragmas which keyword is self pragmaKeyword"

	^ (self pragmaKeywords flatCollect: [ :each | Pragma allNamed: each ])
		select: [ :prg | prg methodSelector numArgs = 1 ]
]
