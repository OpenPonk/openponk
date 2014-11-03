hooks
createModel
	^ self modelClass new
		start: source model;
		end: target model