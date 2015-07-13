inheritance
generalizations
	| result generalization |
	result := Set new.
	
	generalizationSets do: [ :each | 
		generalization := (each search: self name).
		generalization ifNotNil: [
			result add: generalization ]
	].
	
	^ result
	
	