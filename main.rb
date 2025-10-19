require 'json'
require 'thor'
require_relative 'lib/helpers'
require_relative 'lib/config'
require_relative 'lib/language'

class Main < Thor
    desc "new", "Create a new script"
    option :lang, aliases: :l,  type: :string, default: $CONFIG.default_language, desc: "the language of the script"
    option :link, aliases: :b, type: :boolean, default: true, desc: "install to the bin"
    option :edit, aliases: :e, type: :boolean, default: true, desc: "open the script in the editor"
    def new(name)
        lang = find_language(options[:lang]) || raise("Language #{options[:lang]} not found")
        path = lang.path(name)

        ensure_dir lang.scripts_path
        unless File.exist? path
            File.write(path, lang.shebang)
            FileUtils.chmod("+x", path)
        end

        if options[:link]
            bin_path = "#{$BIN}/#{name}"
            unless File.exist? bin_path
                FileUtils.ln_s path, bin_path
            end
        end

        if options[:edit]
            open_editor path
        end
    end
end

Main.start(ARGV)
