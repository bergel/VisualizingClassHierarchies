Class {
	#name : #MClass,
	#superclass : #MObject,
	#instVars : [
		'name',
		'superclassName',
		'superclass',
		'subclassesName',
		'loc',
		'docloc',
		'incomingClassnames',
		'outgoingClassnames',
		'incomingClasses',
		'outgoingClasses',
		'methods'
	],
	#category : #'Mattia-Visualization'
}

{ #category : #initialization }
MClass >> addMethod: aMethod [
	methods add: aMethod 
]

{ #category : #accessing }
MClass >> docloc [

	^ docloc
]

{ #category : #accessing }
MClass >> docloc: anObject [

	docloc := anObject
]

{ #category : #accessing }
MClass >> incomingClasses [

	^ incomingClasses
]

{ #category : #accessing }
MClass >> incomingClassnames [

	^ incomingClassnames
]

{ #category : #accessing }
MClass >> incomingClassnames: anObject [

	incomingClassnames := anObject
]

{ #category : #initialization }
MClass >> initialize [ 
	super initialize.
	name := #UNNAMED.
	superclassName := nil.
	subclassesName := OrderedCollection new.
	docloc := 0.
	incomingClasses := OrderedCollection new.
	outgoingClasses := OrderedCollection new.
	methods := OrderedCollection new
]

{ #category : #accessing }
MClass >> loc [

	^ loc
]

{ #category : #accessing }
MClass >> loc: anObject [

	loc := anObject
]

{ #category : #accessing }
MClass >> methods [

	^ methods
]

{ #category : #accessing }
MClass >> name [

	^ name
]

{ #category : #accessing }
MClass >> name: anObject [

	name := anObject
]

{ #category : #private }
MClass >> numberOfMethods [
	^ methods size
]

{ #category : #accessing }
MClass >> outgoingClasses [

	^ outgoingClasses
]

{ #category : #accessing }
MClass >> outgoingClassnames [

	^ outgoingClassnames
]

{ #category : #accessing }
MClass >> outgoingClassnames: anObject [

	outgoingClassnames := anObject
]

{ #category : #accessing }
MClass >> superclass [
	^ superclass
]

{ #category : #accessing }
MClass >> superclass: aclass [
	superclass := aclass 
]

{ #category : #accessing }
MClass >> superclassName [

	^ superclassName
]

{ #category : #accessing }
MClass >> superclassName: anObject [

	superclassName := anObject
]
