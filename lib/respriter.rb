# frozen_string_literal: true

module Respriter
  def self.root
    @@root ||= File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  def self.dist_dir
    @@dist_dir ||= File.join(root, 'dist')
  end

  def self.defs_dir(scope)
    @@defs_dir ||= File.join(dist_dir, scope, 'defs')
  end

  def self.symbols_dir(scope)
    @@symbols_dir ||= File.join(dist_dir, scope, 'symbols')
  end

  def self.dependencies_file(scope)
    @@dependencies_file = File.join(dist_dir, scope, 'dependencies.json')
  end

  def self.setup(scope)
    FileUtils.mkdir_p(defs_dir(scope)) unless File.exist?(defs_dir(scope))
    FileUtils.mkdir_p(symbols_dir(scope)) unless File.exist?(symbols_dir(scope))
  end
end

require_relative './respriter/version'
require_relative './respriter/dependency_resolver'
require_relative './respriter/builder'
