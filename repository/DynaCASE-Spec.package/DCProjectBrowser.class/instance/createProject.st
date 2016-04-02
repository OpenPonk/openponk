as yet unclassified
createProject
	| project |
	project := DCProject named: projectNameInput text.
	diagramOptions values
		detect: [ :each | each second state ]
		ifFound:
			[ :each | 
			project
				addModel:
					(each first modelClass new
						name: each first name;
						yourself) ].
	self openProject: project