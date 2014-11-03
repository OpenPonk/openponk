validating
isElementValid
	[mixObjects
		detect: [:each | each isKindOf: RigidSortalClass]]
		on: Error
		do: [^ false].
	[mixObjects
		detect: [:each | each isKindOf: AntiRigidSortalClass]]
		on: Error
		do: [^ false].
	^ mixObjects size = 2 & super isElementValid