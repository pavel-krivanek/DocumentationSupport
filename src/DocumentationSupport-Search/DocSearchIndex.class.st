"
I'm a DocSearchIndex which store the book, the chapter and the index of an occurrence.
"
Class {
	#name : #DocSearchIndex,
	#superclass : #Object,
	#instVars : [
		'book',
		'chapter',
		'index'
	],
	#category : #'DocumentationSupport-Search'
}

{ #category : #accessing }
DocSearchIndex class >> index: aBook in: aChapter at: anIndex [
	| index |
	index := self new.
	index book: aBook;
	chapter: aChapter;
	index: anIndex.
	^ index
]

{ #category : #converting }
DocSearchIndex >> asClickPath [
	^ self createPath: chapter.
]

{ #category : #accessing }
DocSearchIndex >> book [
	^ book
]

{ #category : #accessing }
DocSearchIndex >> book: aBook [
	book := aBook
]

{ #category : #accessing }
DocSearchIndex >> chapter [
	^ chapter
]

{ #category : #accessing }
DocSearchIndex >> chapter: aChapter [
	chapter := aChapter
]

{ #category : #converting }
DocSearchIndex >> createPath: aChapter [
	| p |
	p := aChapter parent.
	p class = DocBook 
		ifFalse: [ ^ (self createPath: p) add: (p children indexOf: aChapter);
			yourself ] 
		ifTrue: [ ^ OrderedCollection with: book with: (p children indexOf: aChapter) ] 
]

{ #category : #accessing }
DocSearchIndex >> index [
	^ index
]

{ #category : #accessing }
DocSearchIndex >> index: anIndex [
	index := anIndex
]

{ #category : #testing }
DocSearchIndex >> isEmpty [
	^ book isNil and: [ chapter isNil and: [ index isNil ] ]
]
