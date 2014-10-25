private 
doFix: aShape nearEndOfEdge: anEdge callbacks: callbacks
	self
		doFix: aShape
		nearPoint: (anEdge shape endingPointOf: anEdge)
		ofEdge: anEdge
		using: [ :distance :offset | 
			self
				doStick: aShape
				nearEndOfEdge: anEdge
				distance: distance
				offset: offset
				callbacks: callbacks ]