adding
addElement: anElement checkDuplicity: aDuplicity
	
	aDuplicity
		ifTrue: [ 
			[ modelElements at: anElement name ]
				on: Error
				do: [ 
					anElement metaModel ifNil: [ anElement metaModel: self ].
					modelElements at: anElement name put: anElement ]];
		ifFalse: [ 
			anElement metaModel ifNil: [ anElement metaModel: self ].
			modelElements at: anElement dcID put: anElement ]