reading
fromDirectory: aFolder
	| project |
	project := self readProjectFrom: aFolder / 'project.xml'