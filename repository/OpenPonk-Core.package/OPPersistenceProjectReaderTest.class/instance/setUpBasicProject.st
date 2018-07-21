instance creation
setUpBasicProject
	(project := OPProject new)
		name: 'Test Project';
		uuid: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c').
	memoryRoot := FileSystem memory / 'test-project'.
	project addModel: OPTestContainerModel new.
	OPProjectController new
		project: project;
		saveProjectTo: memoryRoot.
	root := (FileSystem zip: memoryRoot) open