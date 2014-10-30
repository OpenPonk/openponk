as yet unclassified
serializeProject
	| d |
	d := Dictionary new.
	d at: #version put: '1.1'.
	d at: #created put: DateAndTime now.
	d at: #project put: project.
	^ d