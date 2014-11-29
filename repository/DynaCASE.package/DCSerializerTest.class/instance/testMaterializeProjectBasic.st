tests-materializing
testMaterializeProjectBasic
	| d materialized |
	d := Dictionary new.
	d at: #projectName put: 'Some Project'.

	materialized := serializer materializeProjectBasic: d.
	self assert: materialized projectName = 'Some Project'