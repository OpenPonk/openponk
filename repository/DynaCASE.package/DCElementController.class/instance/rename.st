as yet unclassified
rename
	| result modelObject |
	modelObject := self model.
	result := UIManager default request: 'Name' initialAnswer: modelObject name.
	result ifNotNil: [ modelObject name: result ]