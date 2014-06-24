accessing
containingStateMachine
	self stateMachine isNil
		ifTrue: [ ^ self state containingStateMachine ]
		ifFalse: [ ^ self stateMachine ]