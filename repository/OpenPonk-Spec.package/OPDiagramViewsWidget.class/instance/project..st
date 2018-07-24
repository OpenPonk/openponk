accessing
project: aProject
	project := aProject.
	list items: (self viewsIn: aProject).
	project whenChanged: [ list items: (self viewsIn: aProject) ]