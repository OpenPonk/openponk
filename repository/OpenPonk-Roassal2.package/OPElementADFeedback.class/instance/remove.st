protocol
remove
	feedback
		ifNotNil: [ 
			| aView |
			aView := feedback view.
			feedback remove.
			aView signalUpdate.
			feedback := nil ]