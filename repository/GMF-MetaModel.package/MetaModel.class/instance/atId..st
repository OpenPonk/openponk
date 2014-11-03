accessing
atId: anId
	"Return element or association with id anId. Need for import from OLED"
	^ modelElements do: [ :each | 
			each id = anId
				ifTrue: [ ^ each ].
			[ ^ each associations detect: [ :ass | ass id = anId ] ]
				on: Error
				do: [ ] ]