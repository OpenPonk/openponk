instance creation
openProject: aProject
	^ self new
		open;
		openProject: aProject;
		yourself