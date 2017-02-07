loading
loadModelFrom: aFolder
	^ self materializeModelFrom: (aFolder / 'model' , self modelExtension) contents