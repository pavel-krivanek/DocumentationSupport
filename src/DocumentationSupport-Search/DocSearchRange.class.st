Class {
	#name : #DocSearchRange,
	#superclass : #Object,
	#instVars : [
		'chaptersToSearch',
		'posInterval'
	],
	#category : #'DocumentationSupport-Search'
}

{ #category : #API }
DocSearchRange >> chaptersDo: aBlock [
	chaptersToSearch doWithIndex: [ :chapter :index | 
		aBlock value: chapter value: (index = 1 ifTrue: [ posInterval ]).
	]

]

{ #category : #accessing }
DocSearchRange >> chaptersToSearch [
	^ chaptersToSearch
]

{ #category : #accessing }
DocSearchRange >> chaptersToSearch: aChapter [
	chaptersToSearch := aChapter
]

{ #category : #accessing }
DocSearchRange >> posInterval [
	^ posInterval
]

{ #category : #accessing }
DocSearchRange >> posInterval: anInteger [
	posInterval := anInteger
]
