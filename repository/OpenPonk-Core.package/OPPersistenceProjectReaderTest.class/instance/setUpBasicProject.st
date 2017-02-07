instance creation
setUpBasicProject
	(project := OPProject new)
		name: 'Test Project';
		uuid: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c').
	root := FileSystem memory / 'test-project'.
	project addModel: OPNamedElement new.
	OPProjectController new
		project: project;
		saveProjectTo: root