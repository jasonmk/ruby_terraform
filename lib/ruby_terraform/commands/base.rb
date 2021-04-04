require_relative '../errors'
require_relative '../command_line/builder'
require_relative '../command_line/options_factory'

module RubyTerraform
  module Commands
    class Base
      def initialize(
        binary: nil, logger: nil, stdin: nil, stdout: nil, stderr: nil
      )
        @binary = binary || RubyTerraform.configuration.binary
        @logger = logger || RubyTerraform.configuration.logger
        @stdin = stdin || RubyTerraform.configuration.stdin
        @stdout = stdout || RubyTerraform.configuration.stdout
        @stderr = stderr || RubyTerraform.configuration.stderr
        initialize_command
      end

      def execute(opts = {})
        do_before(opts)
        build_and_execute_command(opts)
        do_after(opts)
      rescue Open4::SpawnError
        message = "Failed while running '#{command_name}'."
        logger.error(message)
        raise Errors::ExecutionError, message
      end

      protected

      attr_reader :binary, :logger, :stdin, :stdout, :stderr

      def build_and_execute_command(opts)
        command = build_command(opts)
        logger.debug("Running '#{command}'.")
        command.execute(
          stdin: stdin,
          stdout: stdout,
          stderr: stderr
        )
      end

      def command_name
        self.class.to_s.split('::')[-1].downcase
      end

      def do_before(_opts); end

      def do_after(_opts); end

      private

      def initialize_command; end

      def build_command(opts)
        values = apply_option_defaults_and_overrides(opts)
        RubyTerraform::CommandLine::Builder.new(
          binary: @binary,
          sub_commands: sub_commands(values),
          options: options(values),
          arguments: arguments(values)
        ).build
      end

      def apply_option_defaults_and_overrides(opts)
        option_default_values(opts).merge(opts)
                                   .merge(option_override_values(opts))
      end

      def option_default_values(_values)
        {}
      end

      def option_override_values(_values)
        {}
      end

      def sub_commands(_values)
        []
      end

      def options(values)
        RubyTerraform::CommandLine::OptionsFactory.from(values, switches)
      end

      def switches
        []
      end

      def arguments(_values)
        []
      end
    end
  end
end
