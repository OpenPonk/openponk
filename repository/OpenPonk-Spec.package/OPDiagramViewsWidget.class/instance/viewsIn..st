accessing
viewsIn: aProject
	^ aProject views sorted: #modelType ascending , #modelName ascending , #name descending