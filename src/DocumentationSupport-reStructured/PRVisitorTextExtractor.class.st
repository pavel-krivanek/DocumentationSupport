"
I am a visitor of Pillar nodes that extract just text data discarding the containing structures.
"
Class {
	#name : #PRVisitorTextExtractor,
	#superclass : #PRVisitor,
	#instVars : [
		'writeStream'
	],
	#category : #'DocumentationSupport-reStructured'
}

{ #category : #accessing }
PRVisitorTextExtractor >> value: aPRObject [

	^ (String streamContents: [ :aStream | 
		   writeStream := aStream.
		   aPRObject accept: self.
		   writeStream := nil ]) allButLast: 2
]

{ #category : #'visiting-document' }
PRVisitorTextExtractor >> visitText: anObject [

	anObject text linesDo: [ :aString | 
		writeStream
			nextPutAll: aString;
			crlf ]
]
