saving
removeModelsNotIn: aCollection from: aFolder
	| toDelete ids |
	ids := aCollection collect: [ :each | each uuid asString ].
	toDelete := aFolder children reject: [ :each | ids includes: each basename ].
	toDelete
		do: [ :each | 
			each files do: #delete.
			each delete ]