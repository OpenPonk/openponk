accessing
addTransition: aTransition
	aTransition container: self "todo: not necessarily?".
	transition add: aTransition.
	self announce: (DCObjectAdded object: aTransition container: self)