require 'lino'
require_relative 'base'

module RubyTerraform
  module Commands
    class Refresh < Base
      def configure_command(builder, opts)
        directory = opts[:directory]
        vars = opts[:vars] || {}
        var_file = opts[:var_file]
        var_files = opts[:var_files] || []
        state = opts[:state]
        input = opts[:input]
        target = opts[:target]
        targets = opts[:targets] || []
        no_color = opts[:no_color]

        builder
            .with_subcommand('refresh') do |sub|
              vars.each do |key, value|
                sub = sub.with_option(
                    '-var', "'#{key}=#{value}'", separator: ' ')
              end
              sub = sub.with_option('-var-file', var_file) if var_file
              var_files.each do |file|
                sub = sub.with_option('-var-file', file)
              end
              sub = sub.with_option('-state', state) if state
              sub = sub.with_option('-input', input) if input
              sub = sub.with_option('-target', target) if target
              targets.each do |target_name|
                sub = sub.with_option('-target', target_name)
              end
              sub = sub.with_flag('-no-color') if no_color
              sub
            end
            .with_argument(directory)
      end
    end
  end
end
