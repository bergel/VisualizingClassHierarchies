Class {
	#name : #MPackage,
	#superclass : #MEntity,
	#instVars : [
		'classes'
	],
	#category : #'Mattia-Visualization'
}

{ #category : #adding }
MPackage >> addClass: aMClass [ 
	classes add: aMClass.
]

{ #category : #accessing }
MPackage >> children [
	^ self innerPackages, self classes
]

{ #category : #accessing }
MPackage >> classes [
	^ classes
]

{ #category : #initialization }
MPackage >> initialize [
	super initialize.
	classes := OrderedCollection new.
]

{ #category : #accessing }
MPackage >> innerPackages [
	^ #()
]
