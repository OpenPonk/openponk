validating
isElementValid
	^ (parents anySatisfy: [:each | each isDisjoint & each isComplete])
			& super isElementValid 