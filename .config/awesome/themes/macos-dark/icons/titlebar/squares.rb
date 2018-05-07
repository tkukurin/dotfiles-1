#!/usr/bin/ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

path = "#{File.dirname(__FILE__)}"

configuration = {}
if File.exist?(path + '/squares.yml')
	configuration = YAML::load(File.read(path + '/squares.yml')) || {}
end

def hasOptipng
	return system('optipng -v > /dev/null')
end

def drawCircle(dot, defaults)
	canvasEdge = defaults['canvasSize'].to_s
	strokeWidth = dot['strokeWidth'] || defaults['strokeWidth']
	edge = dot['edge'] || defaults['edge']
	translate = ((canvasEdge.to_i - edge.to_i) / 2).to_s

	# Generate base image
	puts("convert -size " + canvasEdge + "x" + canvasEdge + " xc:none \
						-stroke '#" + dot['stroke'] + "' \
						-fill '#" + dot['fill'] + "' \
						-strokewidth " + strokeWidth.to_s + " \
						-draw 'translate " + translate + "," + translate + " rectangle 0,0 " + edge.to_s + "," + edge.to_s + "' \
						" + dot['name'] + ".png")
	system("convert -size " + canvasEdge + "x" + canvasEdge + " xc:none \
						-stroke '#" + dot['stroke'] + "' \
						-fill '#" + dot['fill'] + "' \
						-strokewidth " + strokeWidth.to_s + " \
						-draw 'translate " + translate + "," + translate + " rectangle 0,0 " + edge.to_s + "," + edge.to_s + "' \
						" + dot['name'] + ".png")

	# Compress image
	if hasOptipng
		system('optipng -o7 ' + dot['name'] + '.png')
	end

	# Copy image to its filenames
	dot['filenames'].each do |name|
		system('cp ' + dot['name'] + '.png ' + name)
	end

	# Remove base image
	system('unlink ' + dot['name'] + '.png ')
end

configuration['squares'].each do |dot|
	drawCircle(dot, configuration['defaults'])
end

