instance creation
positions
	^ {(label
		->
			{(DCRTLPositionNode new
				model: self initialPositions first;
				index: 1).
			(DCRTLPositionNode new
				model: self initialPositions second;
				index: 2)})} asOrderedDictionary