class CodeAnalyzer
  attr_reader :language, :code, :commit_id

  def initialize(options = {})
    @language = options[:language]
    @code = options[:code]
    @commit_id = options[:commit_id]
  end

  def run
    "---common---"
  end

  def self.build(options = {})
    options[:language] ||= ""
    if options[:language].strip.empty?
      CodeAnalyzer.new(options)
    else
      klass = options[:language].strip.capitalize
      if defined?(klass) && klass.is_a?(Class)
        const_get(klass).new(options)
      else
        CodeAnalyzer.new(options)
      end
    end
  end
end

class Ruby < CodeAnalyzer
  def run
    unless ENV.fetch('RACK_ENV') == "test"
      file_name = "#{settings.root}/rubocop_tmp/test_#{user.id}.rb"
      rubocop_code_file = File.new(file_name, "w+")
      rubocop_code_file.write code
      rubocop_code_file.rewind
      analysis = `rubocop "#{rubocop_code_file.path}"`
      File.delete rubocop_code_file.path
      analysis
    end
  end
end

class Java < CodeAnalyzer
  def run
    "---java---"
  end
end
