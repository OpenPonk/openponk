accessing
model: aModel
	model := aModel.
	model
		when: DCElementAdded
		do: [ :event | 
			self addModelElement: event element.
			self updateView ]