require_relative 'helpers'

class Language 
    attr_reader :name, :extension, :interpreter
    
    def initialize(name, extension)
        @name = name
        @extension = extension
        @interpreter = $CONFIG.interpreter(name)

        ensure_dir scripts_path
    end

    def shebang
        "#!/usr/bin/env #{@interpreter}\n"
    end

    def scripts_path
        File.join($SCRIPTS_PATH, @name)
    end

    def path(script_name)
        "#{scripts_path}/#{script_name}.#{@extension}"
    end

    def run(script_name)
        script_path = path(script_name)
        system "#{@interpreter} #{script_path}"
    end
end

languages_array = [
    Language.new('ruby', 'rb'),
    Language.new('python', 'py'),
    Language.new('javascript', 'js'),
    Language.new('typescript', 'ts'),
    Language.new('zsh', 'sh'),
    Language.new('bash', 'sh'),
]

$languages = languages_array.map { |lang| [lang.name, lang] }.to_h
$languages_by_extension = languages_array.map { |lang| [lang.extension, lang] }.to_h

