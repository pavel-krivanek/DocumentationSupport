"
I'm a DocSearchIndex which store the book, the chapter and the index of an occurrence.
"
Class {
	#name : #DocResultEntry,
	#superclass : #Object,
	#instVars : [
		'chapter',
		'startPosition',
		'endPosition'
	],
	#category : #'DocumentationSupport-Search'
}

{ #category : #accessing }
DocResultEntry >> chapter [
	^ chapter
]

{ #category : #accessing }
DocResultEntry >> chapter: aChapter [
	chapter := aChapter
]

{ #category : #accessing }
DocResultEntry >> endPosition [

	^ endPosition
]

{ #category : #accessing }
DocResultEntry >> endPosition: anObject [

	endPosition := anObject
]

{ #category : #accessing }
DocResultEntry >> startPosition [

	^ startPosition
]

{ #category : #accessing }
DocResultEntry >> startPosition: anObject [

	startPosition := anObject
]
