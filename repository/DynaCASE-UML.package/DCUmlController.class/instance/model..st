accessing
model: aFsmModel
	model := aFsmModel.
	model
		when: DCElementAdded
		do: [ :event | 
			self addModelElement: event element.
			self updateView ]