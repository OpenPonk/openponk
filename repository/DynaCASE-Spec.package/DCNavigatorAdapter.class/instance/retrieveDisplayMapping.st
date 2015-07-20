private
retrieveDisplayMapping
	^ displayMapping ifNil: [ displayMapping := self displayMapping asDictionary ]