accessing
generateLayout
	| states transitions region |
	layout := nil.
	region := self model region first.
	states := region subvertex.
	transitions := region transition.
	self processStates: states.
	self processTransitions: transitions