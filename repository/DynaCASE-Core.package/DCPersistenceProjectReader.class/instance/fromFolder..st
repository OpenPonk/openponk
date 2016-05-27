public
fromFolder: aFolder
	| project |
	project := self readProjectFrom: aFolder / 'project.xml'.
	(self readAllMementosFrom: aFolder) do: [ :each | project addModel: each model ].
	^ project