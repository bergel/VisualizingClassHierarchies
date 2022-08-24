Class {
	#name : #MEntity,
	#superclass : #Object,
	#instVars : [
		'name',
		'parent'
	],
	#category : #'Mattia-Visualization'
}

{ #category : #accessing }
MEntity >> children [
	^ self subclassResponsibility
]

{ #category : #accessing }
MEntity >> name [

	^ name
]

{ #category : #accessing }
MEntity >> name: anObject [

	name := anObject
]

{ #category : #accessing }
MEntity >> parent [
	^ parent
]
