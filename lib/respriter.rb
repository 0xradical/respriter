module Respriter
  def self.root
    @@root ||= File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  def self.dist_dir
    @@dist_dir ||= File.join(root, 'dist')
  end

  def self.defs_dir
    @@defs_dir ||= File.join(dist_dir, 'defs')
  end

  def self.symbols_dir
    @@symbols_dir ||= File.join(dist_dir, 'symbols')
  end

  def self.dependencies_file
    @@dependencies_file = File.join(dist_dir, 'dependencies.json')
  end

  def self.setup
    Dir.mkdir(dist_dir) unless File.exist?(dist_dir)
    Dir.mkdir(defs_dir) unless File.exist?(defs_dir)
    Dir.mkdir(symbols_dir) unless File.exist?(symbols_dir)
  end
end

require_relative './respriter/version'
require_relative './respriter/dependency_resolver'
require_relative './respriter/builder'

# frozen_string_literal: true

# require 'json'

# ROOT    = File.expand_path(File.join(File.dirname(__FILE__), '..'))
# dist    = File.join(ROOT, 'dist')
# defs    = File.join(dist, 'defs')
# symbols = File.join(dist, 'symbols')

# dependencies = JSON.parse(File.read(File.join(dist, 'dependencies.json')))

# puts ARGV[0]
# tags = %w[computer_science ruby_programming]

# tag_dependencies = tags.flat_map do |tag|
#   dependencies['tags-' + tag]
# end.compact

# output = StringIO.new
# output.write(%(<svg xmlns="http://www.w3.org/2000/svg">))
# tag_dependencies.each do |dep|
#   output.write(File.read(File.join(defs, dep)))
# end
# tags.each do |tag|
#   output.write(File.read(File.join(symbols, 'tags-' + tag)))
# end
# output.write(%(</svg>))
# output.rewind
# puts output.read
