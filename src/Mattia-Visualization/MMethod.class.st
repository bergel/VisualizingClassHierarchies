Class {
	#name : #MMethod,
	#superclass : #MObject,
	#instVars : [
		'name',
		'documentation',
		'signature'
	],
	#category : #'Mattia-Visualization'
}

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

{ #category : #accessing }
MMethod >> name [

	^ name
]

{ #category : #accessing }
MMethod >> name: anObject [

	name := anObject
]

{ #category : #accessing }
MMethod >> signature [

	^ signature
]

{ #category : #accessing }
MMethod >> signature: anObject [

	signature := anObject
]
