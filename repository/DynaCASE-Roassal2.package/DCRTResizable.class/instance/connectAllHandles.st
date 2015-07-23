hooks
connectAllHandles
	handles
		withIndexDo: [ :each :i | 
			| to |
			to := handles at: i % handles size + 1.
			element view
				add:
					(RTLine new
						color: ((Color gray) alpha: 0.5);
						edgeFrom: each to: to) ]