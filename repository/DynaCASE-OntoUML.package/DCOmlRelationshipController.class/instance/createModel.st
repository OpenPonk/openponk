hooks
createModel
	^ self modelClass new
		start: source model;
		end: target model;
		startMultiplicity: 1;
		endMultiplicity: 1;
		yourself