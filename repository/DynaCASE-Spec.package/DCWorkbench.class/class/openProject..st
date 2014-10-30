project handling
openProject: aProject
	^ self new
		open;
		openProject: aProject;
		yourself