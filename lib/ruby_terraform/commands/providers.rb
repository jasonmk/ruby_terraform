# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    # Wraps the +terraform providers+ command which prints out a tree of modules
    # in the referenced configuration annotated with their provider
    # requirements.
    #
    # This provides an overview of all of the provider requirements across all
    # referenced modules, as an aid to understanding why particular provider
    # plugins are needed and why particular versions are selected.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Plan} via {#execute}, the following
    # options are supported:
    #
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Providers.new.execute
    #
    class Providers < Base
      include RubyTerraform::Options::Common

      # @!visibility private
      def subcommands
        %w[providers]
      end

      # @todo Add directory argument
    end
  end
end
