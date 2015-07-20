initialize-release
initialize
	super initialize.

	name := nil.
	attributes := OrderedCollection new.
	methods := OrderedCollection new.
	associations := OrderedCollection new.
	parents := Set new.
	transformed := false.
	abstract := false.
	generalizationSets := Set new.
	children := Set new