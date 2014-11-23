hooks
createModel
	^ self modelClass new
		child: source model;
		parent: target model