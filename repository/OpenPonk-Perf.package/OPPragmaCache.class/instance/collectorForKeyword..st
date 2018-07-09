initialization
collectorForKeyword: aKeyword
	useCache
		ifFalse: [ ^ self newCollectorForKeyword: aKeyword ].
	^ collectors at: aKeyword ifAbsentPut: [ self newCollectorForKeyword: aKeyword ]