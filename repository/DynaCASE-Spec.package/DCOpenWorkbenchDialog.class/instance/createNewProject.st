as yet unclassified
createNewProject
	| name |
	name := UIManager default request: 'Project name' initialAnswer: 'New Project'.
	name
		ifNotNil: [ 
			DCWorkbench openNewProject: name.
			self delete ]