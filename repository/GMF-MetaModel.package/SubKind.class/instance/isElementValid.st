validating
isElementValid
	parents do: [:each | 
		( each parentClass isKindOf: SubstanceSortal ) ifTrue: [ ^ super isElementValid ].
		( each parentClass isMemberOf: SubKind ) ifTrue: [ ^ each parentClass isElementValid ] ].

     ^ false.