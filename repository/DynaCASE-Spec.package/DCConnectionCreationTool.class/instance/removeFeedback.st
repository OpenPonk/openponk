private
removeFeedback
	| view |
	feedback
		ifNotNil: [ 
			view := feedback view.
			feedback remove.
			view signalUpdate ].
	feedback := nil