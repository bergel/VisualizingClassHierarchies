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
		'documentation',
		'metrics'
	],
	#category : #'Mattia-Visualization'
}

{ #category : #initialization }
MClass >> addMethod: aMethod [
	methods add: aMethod 
]

{ #category : #visualization }
MClass >> asShape [
	"Return a RSComponent"

	| c defaultHeight color compositeShape |
	defaultHeight := self documentedLoc + 5.
	c := OrderedCollection new.
	c add: (RSBox new
					height: defaultHeight;
					width: incomingClasses size * 3 + 5
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
	compositeShape := c asArray asShapeFor: self.
	^ compositeShape
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

{ #category : #visualization }
MClass >> documentedLoc [
	^ documentation lines size + ((self methods collect: #documentedLoc), { 0 }) sum
]

{ #category : #visualization }
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
	methods := OrderedCollection new.
	metrics := Dictionary new
]

{ #category : #inspecting }
MClass >> inspectorCanvasContext: aContext [

	aContext withoutEvaluator
]

{ #category : #inspecting }
MClass >> inspectorMethods [
	<inspectorPresentationOrder: 90 title: 'Methods'>
	^ SpListPresenter new
		items: self methods;
		display: [ :m | m signature ];
		yourself.
]

{ #category : #inspecting }
MClass >> inspectorText [
	<inspectorPresentationOrder: 90 title: 'My description'>
	^ SpTextPresenter new
		text: 'OrderedCollection of size = ', self numberOfMethods asString;
		yourself.
]

{ #category : #testing }
MClass >> isRoot [
	^ superclass isNil
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
MClass >> metrics [
	"Return a dictionary containing metric values associated to the class"
	^ metrics
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

{ #category : #visualization }
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

{ #category : #visualization }
MClass >> visualizeFanInFanOut [

	| cls c fanInShapes fanIn fanOutShapes fanOut |
	cls := self.
	c := RSCanvas new.
	"FAN-IN:"
	fanInShapes := self incomingClasses collect: #asShape as: RSGroup.
	RSVerticalLineLayout on: fanInShapes.
	fanIn := fanInShapes asShape.
	c add: fanIn.

	"Class"
	cls := self asShape.
	c add: cls.

	"FAN-OUT:"
	fanOutShapes := self incomingClasses collect: #asShape as: RSGroup.
	RSVerticalLineLayout on: fanOutShapes.
	fanOut := fanOutShapes asShape.
	c add: fanOut.

	"EDGES"
	fanInShapes do: [ :fis | c add: (RSLine new from: fis; to: cls) ].
	fanOutShapes do: [ :fos | c add: (RSLine new from: cls; to: fos) ].

	RSHorizontalLineLayout new gapSize: 40; alignMiddle; on: c shapes.
	^ c @ RSCanvasController
]
