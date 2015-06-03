removing
removeElement: anElement
	| removed |
	removed := OrderedCollection new.
	
	anElement associations do: [ :each | 
		removed add: each.
		each start removeAssociation: each name.
		each end removeAssociation: each name ].
	
	anElement generalizationSets do: [ :each | 
		removed add: (each remove: anElement name)].
	
	anElement children do: [ :child | 
		child generalizationSets do: [ :each | 
			[ removed add: (each remove: child name) ]
				on: Error
				do: [  ]
			]].
	
	removed add: anElement.
	modelElements removeKey: anElement name.
	^ removed
