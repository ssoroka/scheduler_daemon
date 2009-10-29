class FindRailsRoot
  class << self
    def locate
      dir_arg = ARGV.detect{|arg| arg =~ /^#{Regexp.escape("--dir=")}/ }
      return dir_arg.split('=').last if dir_arg
      return RAILS_ROOT if defined?(RAILS_ROOT)
      return Dir.pwd if current_dir_is_a_rails_project?
      missing_rails_root
    end

    def missing_rails_root
      msg = %(
        Couldn't find rails project. Looked in:
          1. environment variable RAILS_ROOT
          2. --dir=/my/rails/root parameter
          3. current directory (#{Dir.pwd})
        Don't know where to look for tasks.
      )
      raise msg
    end

    def current_dir_is_a_rails_project?
      expected_dirs = %w(app vendor script config public)
      expected_dirs.all?{|dir| Dir[dir].any? }
    end
  end
end