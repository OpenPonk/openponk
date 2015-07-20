private
retrieveIconMapping
	^ iconMapping ifNil: [ iconMapping := self iconMapping asDictionary ]