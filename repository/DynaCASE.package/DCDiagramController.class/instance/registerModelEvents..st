events - registering
registerModelEvents: aModel
	aModel
		when: DCElementRemoved
		do: [ :event |
			self removeControllerOf: event element.
			self updateView ]