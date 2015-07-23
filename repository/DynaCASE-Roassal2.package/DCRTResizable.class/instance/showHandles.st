hooks
showHandles
	handles ifNotEmpty: [ ^ self ].
	handles := DCRTRectangle cornersAndSides
		collect: [ :corner | 
			| handle |
			handle := self createHandle.
			self attachHandle: handle toCorner: corner.
			handle ].
	self connectAllHandles.
	element view addAll: handles.
	element view signalUpdate