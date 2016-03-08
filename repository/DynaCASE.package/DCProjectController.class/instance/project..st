accessing
project: aProject
	project := aProject.
	project fileName
		ifNotNil: [ lastSave := self loadStateFrom: project fileName.
			[ project diagrams isNotEmpty ]
				whileTrue: [ project removeDiagram: project diagrams anyOne ].
			(lastSave at: #diagrams)
				valuesDo: [ :each | 
					| dict |
					dict := #DCFsmGraphML asClass new import: each.
					project addDiagram: (dict at: #model).
					project layout: (dict at: #layout) for: (dict at: #model) ] ]