cost
penaltyForOrientation: aPosition of: anEdge
	self preferences
		at: aPosition feature
		ifPresent:
			[ :val | 
			val second = #top
				ifTrue:
					[ aPosition orientation = #topLeft | (aPosition orientation = #topRight)
						ifTrue: [ ^ 0 ]
						ifFalse: [ ^ 4 ] ].
			val second = #bottom
				ifTrue:
					[ aPosition orientation = #bottomLeft | (aPosition orientation = #bottomRight)
						ifTrue: [ ^ 0 ]
						ifFalse: [ ^ 4 ] ] ]
		ifAbsent: [ ^ 0 ]