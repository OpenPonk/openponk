saving
modelMementos
	^ self project models collect: [ :each | self modelMementoFor: each ]