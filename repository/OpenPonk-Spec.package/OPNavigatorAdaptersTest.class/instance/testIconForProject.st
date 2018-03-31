running
testIconForProject
	self
		assert: (adapters iconFor: OPProject new) bits
		equals: OPIcons current openponkIcon bits