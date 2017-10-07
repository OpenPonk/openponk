as yet unclassified
sampleExampleEdit
| page playground |
(page := GTPlayPage new)
	saveContent: '|v|
v := RTView new.

^ v'.
(playground := GTPlayground new)
	openOn: page.

OPRTExamples new installTitle: 'label' capitalized code: page content.

page saveContent: 'new content'.
playground update.