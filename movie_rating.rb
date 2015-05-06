require 'pry'
require 'imdb'

class OpenFile

	def initialize(file)
		@file = file
	end

	def open 
		titles = IO.readlines(@file)
	end
end

class SearchMovie

	def initialize(titles_collection)
		@titles_collection = titles_collection
		@titles_rating_hash = {}
	end

	def rate
		@titles_collection.each do |title|

			movie = Imdb::Search.new(title).movies.take(1)
			@titles_rating_hash[title.chomp] = movie[0].rating
		end
		@titles_rating_hash
	end
end

class PrintGraph

	def initialize(titles_rating_hash)
		@titles_rating_hash = titles_rating_hash
	end

	def to_print

		band = Band.new
		
		(1..8).to_a.reverse.each do |i|

			@titles_rating_hash.each do |title, rate|
				band.print_height(i, rate)
			end

			print "|\n"
		end

		lines = Line.new
		lines.print_lines(@titles_rating_hash.size)

		numbers = Numbers.new
		numbers.print_numbers(@titles_rating_hash.size)

		list = List.new
		list.print_list(@titles_rating_hash)	
	end	
end

class Band

	def print_height(num, rate)
		if(rate >= num)
				print "|*"
			else
				print "| "
			end
	end
end

class Line

	def print_lines(length)
		(1..length).each do
				print "--"
			end
		print "\n"
	end
end

class Numbers

	def print_numbers(length)
	(1..length).each_with_index do |i|
			
				print "|#{i}"
	end
		print "|\n"
	end
end

class List

	def print_list(list)
		list.each_with_index do |title, i|
			i+=1
			puts "\n #{i}. #{title[0]}"
		end
	end
end

open_file = OpenFile.new("movies.txt")
titles_collection = open_file.open

search = SearchMovie.new(titles_collection)
titles_rating_hash = search.rate

graph = PrintGraph.new(titles_rating_hash)
graph.to_print