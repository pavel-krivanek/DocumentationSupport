"
I am a documentation repository that uses a folder structure on disc.
"
Class {
	#name : #DocFileLibraryRepository,
	#superclass : #DocLibraryRepository,
	#instVars : [
		'folder'
	],
	#category : #'DocumentationSupport-Model'
}

{ #category : #converting }
DocFileLibraryRepository >> convertDocBookToReStructuredText: aDocBook onPath: bookletPath [

	(bookletPath / (aDocBook key , '.rst'))
		delete;
		writeStreamDo: [ :aStream | 
			| title |
			title := aDocBook name.
			aStream
				nextPutAll: title;
				crlf;
				nextPutAll: ('' join: ((1 to: title size) collect: [ :_ | '#' ]));
				crlf;
				crlf.
				
			aDocBook chapters do: [ :each | 
				aStream
					nextPutAll: '.. include:: ';
					nextPutAll: each key;
					nextPutAll: '.rst';
					crlf.
				self convertDocChapterToReStructuredText: each onPath: bookletPath ] ]
]

{ #category : #converting }
DocFileLibraryRepository >> convertDocChapterToReStructuredText: aDocChapter onPath: bookletPath [

	(bookletPath / (aDocChapter key , '.rst'))
		delete;
		writeStreamDo: [ :aStream | 
			| title builder tree visitor |
			title := aDocChapter name.

			aStream
				nextPutAll: '.. _';
				nextPutAll: (title copyReplaceAll: ' ' with: '-');
				nextPutAll: ':';
				crlf;
				crlf.";
				nextPutAll: title;
				crlf;
				nextPutAll: ('' join: ((1 to: title size) collect: [ :_ | '*' ]));
				crlf;
				crlf."

			builder := MicroDownParser builder.
			builder text: aDocChapter source.
			tree := MicroDownParser new parse: builder contents.
			visitor := PRVisitorReStructuredTextConverter new
				           writeStream: aStream;
				           yourself.
			tree asPillar accept: visitor.

			visitor metaExportInFileReference:
				(bookletPath / 'jsons' / (aDocChapter key , '.json'))
					asFileReference ].

	aDocChapter children do: [ :each | 
		self convertDocChapterToReStructuredText: each onPath: bookletPath ]
]

{ #category : #converting }
DocFileLibraryRepository >> convertDocLibraryToReStructuredText: aLibrary [

	| bookletPath indexRSTFile |
	bookletPath := folder parent / 'doc-reSTs' / aLibrary name / 'source'.

	indexRSTFile := bookletPath / 'index.rst'.

	indexRSTFile
		delete;
		writeStreamDo: [ :aStream | 
			| title |
			title := aLibrary name , ' library'.
			aStream
				nextPutAll:
					('.. Documaps documentation master file, created by `sphinx-quickstart` on {1}. You can adapt this file completely to your liking, but it should at least contain the root `toctree` directive.' 
						 format: { DateAndTime now });
				crlf;
				crlf;
				nextPutAll: title;
				crlf;
				nextPutAll:
					('' join: ((1 to: title size) collect: [ :each | '=' ]));
				crlf;
				crlf;
				nextPutAll: '.. toctree::';
				crlf;
				nextPutAll: '  :maxdepth: 2';
				crlf;
				nextPutAll: '  :caption: Books:';
				crlf;
				crlf.

			aLibrary books do: [ :each | 
				aStream
					nextPutAll: '  ';
					nextPutAll: each key;
					nextPutAll: '.rst';
					crlf.

				self convertDocBookToReStructuredText: each onPath: bookletPath ].

			aStream
				crlf;
				nextPutAll: 'Indices and tables';
				crlf;
				nextPutAll: '==================';
				crlf;
				crlf;
				nextPutAll: '* :ref:`genindex`';
				crlf;
				nextPutAll: '* :ref:`search`';
				crlf ]
]

{ #category : #exporting }
DocFileLibraryRepository >> export: aLibrary [ 

	| serializer |

	serializer := DocSerializerSton new.
	serializer export: aLibrary to: self folder.

]

{ #category : #accessing }
DocFileLibraryRepository >> folder [

	^ folder
]

{ #category : #accessing }
DocFileLibraryRepository >> folder: anObject [

	folder := anObject
]

{ #category : #accessing }
DocFileLibraryRepository >> libraries [  

	| materializer |
	
	materializer := DocMaterializerSton new.

	^ folder directories collect: [ :dir |
		| aLibrary |
		aLibrary := materializer readLibraryFrom: dir.
		aLibrary repository: self.
		aLibrary
	]
]
