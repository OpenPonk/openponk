accessing
name
	name ifNil: [ name := DCVisualText new text: 'StateName' ].
	^ name