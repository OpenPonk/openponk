running
setUp
	true ifTrue: [ ^ self skip ].
	view := RTView new.
	ctrl := self createController