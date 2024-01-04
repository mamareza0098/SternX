#!/bin/sh
swiftc CLI.swift Models/Post.swift  Modules/Data\ Processing/DataProcessor.swift \
	Modules/PostsLoader/HTTPClient.swift Modules/PostsLoader/PostLoader.swift \
		Modules/PostsLoader/PostsMapper.swift Modules/Report\ Data/ReportGenerator.swift -o SternX 