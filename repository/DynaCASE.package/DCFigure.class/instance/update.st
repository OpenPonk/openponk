rendering
update
	view ifNil: [ ^ nil ].
	2
		timesRepeat: [ 
			self figures do: #update.
			self layoutOn: self figures.
			self updateBackground ].
	view signalUpdate