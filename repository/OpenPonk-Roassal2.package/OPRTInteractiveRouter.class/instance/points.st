accessing
points
	points isEmpty ifTrue: [ ^ {} ].
	^ points asArray collect: #value