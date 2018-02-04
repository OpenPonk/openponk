accessing
project: aProject
	project := aProject.
	list items: (self diagramsIn: aProject).
	project whenChanged: [ list items: (self diagramsIn: aProject) ]