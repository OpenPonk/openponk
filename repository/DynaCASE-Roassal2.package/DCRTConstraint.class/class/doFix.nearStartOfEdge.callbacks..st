private 
doFix: aShape nearStartOfEdge: anEdge callbacks: callbacks
	self
		doFix: aShape
		nearPoint: (anEdge shape startingPointOf: anEdge)
		ofEdge: anEdge
		using: [ :distance :offset | 
			self
				doStick: aShape
				nearStartOfEdge: anEdge
				distance: distance
				offset: offset
				callbacks: callbacks ]