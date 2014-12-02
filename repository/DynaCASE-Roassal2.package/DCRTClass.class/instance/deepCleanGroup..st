updating
deepCleanGroup: aGroup
	aGroup do: [ :each | each remove ].
	aGroup removeAll