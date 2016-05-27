instance creation
setUpBasicProject
	(project := DCProject new) name: 'Test Project'.
	root := FileSystem memory / 'test-project'.
	project addModel: DCNamedElement new.
	DCProjectController new
		project: project;
		saveProjectTo: root