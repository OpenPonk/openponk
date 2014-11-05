hooks
createModel
	^ self modelClass new
		child: source model;
		parentClass: target model