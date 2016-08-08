as yet unclassified
createProject
	| project |
	project := DCProject named: projectNameInput text.
	diagramOptions values
		detect: [ :each | each second state ]
		ifFound: [ :each | 
			project
				addModel:
					(each first modelClass new
						name: projectNameInput text;
						yourself) ].
	self openProject: project