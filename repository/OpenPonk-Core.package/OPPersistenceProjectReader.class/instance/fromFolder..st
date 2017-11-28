public - reading
fromFolder: aFolder
	| project |
	project := self readProjectFrom: aFolder / 'project.json'.
	(self readAllMementosFrom: aFolder)
		do: [ :each | 
			project addModel: each model.
			project layout: each diagram for: each model ].
	^ project