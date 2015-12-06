as yet unclassified
createProject
	| project |
	project := DCProject named: projectNameInput text.
	diagramOptions values
		detect: [ :each | each second state ]
		ifFound:
			[ :each | 
			project
				addDiagram:
					(each first diagramClass new
						name: each first name;
						yourself) ].
	project open.
	self delete