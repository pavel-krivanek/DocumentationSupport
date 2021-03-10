"
I am a visitor that recursively walk a chapter and collect a bidirectional map over the domain of pairs among classes and compiled methods.
"
Class {
	#name : #PRVisitorClassOrMethodInChapterMapping,
	#superclass : #PRVisitor,
	#instVars : [
		'compiledMethods',
		'classes'
	],
	#category : #DocumentationSupport
}

{ #category : #accessing }
PRVisitorClassOrMethodInChapterMapping >> classes [

	^ classes
]

{ #category : #accessing }
PRVisitorClassOrMethodInChapterMapping >> compiledMethods [

	^ compiledMethods
]

{ #category : #initialization }
PRVisitorClassOrMethodInChapterMapping >> initialize [

	classes := OrderedCollection new.
	compiledMethods := OrderedCollection new
]

{ #category : #'visiting-document' }
PRVisitorClassOrMethodInChapterMapping >> visitMonospaceFormat: anObject [

	| aString |
	aString := PRVisitorTextExtractor new value: anObject.

	(Smalltalk classNamed: aString)
		ifNil: [ 
			| pair |
			pair := aString splitOn: '>>#'.
			pair size = 2 ifTrue: [ 
				| aClass aSelector |
				aClass := Smalltalk classNamed: pair first.
				aSelector := Symbol findInternedSelector: pair second.
				(aClass isNotNil and: [ aSelector isNotNil ]) ifTrue: [ 
					compiledMethods add: aClass >> aSelector ] ] ]
		ifNotNil: [ :aClass | classes add: aClass ]
]
