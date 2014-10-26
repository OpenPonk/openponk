selection handling
cancelFocus
	focusedController
		ifNotNil: [ 
			focusedController := nil.
			self owner cancelFocus ]