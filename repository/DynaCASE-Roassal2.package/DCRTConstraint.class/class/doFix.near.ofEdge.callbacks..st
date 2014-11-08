private 
doFix: aShape near: startOrEnd ofEdge: anEdge callbacks: callbacks
	self
		doFix: aShape
		nearPoint: (anEdge shape perform: (startOrEnd , 'ingPointOf:') asSymbol with: anEdge)
		ofEdge: anEdge
		using: [ :distance :offset | 
			self
				doStick: aShape
				near: startOrEnd
				ofEdge: anEdge
				distance: distance
				offset: offset
				callbacks: callbacks ]