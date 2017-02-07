accessing
project: aProject
	project := aProject.
	project fileName
		ifNotNil: [ lastSave := self loadStateFrom: project fileName.
			[ project models isNotEmpty ]
				whileTrue: [ project removeModel: project models anyOne ].
			(lastSave at: #models)
				valuesDo: [ :each | 
					| dict |
					dict := #OPFsmGraphML asClass new import: each.
					project addModel: (dict at: #model).
					project layout: (dict at: #layout) for: (dict at: #model) ] ]