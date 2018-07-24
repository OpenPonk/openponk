accessing
viewsIn: aProject
	^ aProject views sorted: #modelType descending , #modelName ascending , #name descending