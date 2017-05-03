events - registering
registerModelEvents: aModel
	super registerModelEvents: aModel.
	aModel announcer when: OPElementChanged do: [ :evt | self saveState ]