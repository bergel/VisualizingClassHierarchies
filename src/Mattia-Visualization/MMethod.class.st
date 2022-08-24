Class {
	#name : #MMethod,
	#superclass : #MEntity,
	#instVars : [
		'documentation',
		'signature',
		'sourceCode'
	],
	#category : #'Mattia-Visualization'
}

{ #category : #accessing }
MMethod >> children [
	^ #()
]

{ #category : #accessing }
MMethod >> documentation [

	^ documentation
]

{ #category : #accessing }
MMethod >> documentation: anObject [

	documentation := anObject
]

{ #category : #'as yet unclassified' }
MMethod >> documentedLoc [
	^ documentation lines size
]

{ #category : #testing }
MMethod >> hasComment [
	^ documentation notEmpty
]

{ #category : #testing }
MMethod >> hasDocumentation [
	^ documentation notEmpty
]

{ #category : #initialization }
MMethod >> initialize [
	super initialize.
	sourceCode := 'MISSING'
]

{ #category : #'as yet unclassified' }
MMethod >> inspectorSourceCode [
	<inspectorPresentationOrder: 90 title: 'Source code'>
	^ SpTextPresenter new
		text: self sourceCode;
		yourself.
]

{ #category : #accessing }
MMethod >> signature [

	^ signature
]

{ #category : #accessing }
MMethod >> signature: anObject [
	signature := anObject.
	name := signature
]

{ #category : #accessing }
MMethod >> sourceCode [

	^ sourceCode
]

{ #category : #accessing }
MMethod >> sourceCode: aString [

	sourceCode := aString
]
