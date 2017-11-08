deprecated
registerModelEvents: aModel
	self deprecated: 'Use #model: and #internalSubscribeTo: instead'.
	"super registerModelEvents: aModel.
	aModel announcer when: OPElementChanged do: [ :evt | self saveState ]"