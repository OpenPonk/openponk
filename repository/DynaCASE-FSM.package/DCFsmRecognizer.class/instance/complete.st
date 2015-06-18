terminators
complete
	accepts := remainder isEmpty and: [ state isFinal ].
	completed := true.
	self announce: (DCFsmStateCompleted state: state)