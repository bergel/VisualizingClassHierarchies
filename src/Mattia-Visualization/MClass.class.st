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
		'methods',
		'documentation'
	],
	#category : #'Mattia-Visualization'
}

{ #category : #initialization }
MClass >> addMethod: aMethod [
	methods add: aMethod 
]

{ #category : #'as yet unclassified' }
MClass >> asShape [
	"Return a RSComponent"

	| c defaultHeight color |
	defaultHeight := self documentedLoc + 5.
	c := OrderedCollection new.
	c add: (RSBox new
					height: defaultHeight;
					width: incomingClasses size * 3
				).
				
	color := self hasComment 
						ifTrue: [ documentation notEmpty 
											ifTrue: [ Color r: 0.7 g: 1.0 b: 0.7 ] 
											ifFalse: [ Color orange lighter lighter ]
											] 
						ifFalse: [ Color red ].
						
		
	c add: (RSBox new 
				height: defaultHeight;
				width: self numberOfMethods * 3;
				model: self; color: color).
	c add: (RSBox new
					height: defaultHeight;
					width: outgoingClasses size * 3
				).
	RSHorizontalLineLayout new gapSize: -1; on: c.
	^ c asArray asShapeFor: self
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
MClass >> documentation [

	^ documentation
]

{ #category : #accessing }
MClass >> documentation: anObject [

	documentation := anObject
]

{ #category : #'as yet unclassified' }
MClass >> documentedLoc [
	^ documentation lines size + ((self methods collect: #documentedLoc), { 0 }) sum
]

{ #category : #'as yet unclassified' }
MClass >> hasComment [
	^ documentation notEmpty or: [ self methods anySatisfy: #hasComment ]
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

{ #category : #printing }
MClass >> printOn: str [
	str nextPut: $<.
	str nextPutAll: name.
	str nextPut: $>.
]

{ #category : #'as yet unclassified' }
MClass >> ratioOfDocumentedMethodsAsString [
	| nbOfDocumentedMethods |
	nbOfDocumentedMethods := (self methods select: [ :m | m documentation notEmpty ]) size.
	
	^ nbOfDocumentedMethods asString, '/', methods size asString
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
