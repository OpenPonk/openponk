cost
penaltyForRanking: aPosition of: anEdge
	self preferences
		at: aPosition feature
		ifPresent:
			[ :pref | 
			pref first = #min
				ifTrue: [ ^ aPosition ranking ].
			pref first = #max
				ifTrue: [ ^ aPosition maxRanking - aPosition ranking ] ]
		ifAbsent: [ ^ aPosition ranking ]