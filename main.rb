# use JSON
require 'json'
require 'yaml'
require 'thor'
require 'fileutils'

$CONFIG_PATH = File.join(ENV['HOME'], '.scrman', 'config.yml')
$SCRIPTS_PATH = File.join(ENV['HOME'], '.scrman', 'scripts')
$RUBY_SCRIPTS_PATH = File.join($SCRIPTS_PATH, 'ruby')

for path in [$CONFIG_PATH, $SCRIPTS_PATH, $RUBY_SCRIPTS_PATH]
    unless File.exist? path
        FileUtils.mkdir_p(path)
    end
end

unless File.exist?($CONFIG_PATH)
    FileUtils.mkdir_p(File.dirname($CONFIG_PATH))
    File.write($CONFIG_PATH, { 
        'version' => '0.0.1',
        'editor' => 'vim',
        'bin' => File.join(ENV['HOME'], '.local', 'bin'),
    }.to_yaml)
end

$CONFIG = YAML.load_file($CONFIG_PATH)
$BIN = $CONFIG['bin']

def open_editor(file)
    editor = $CONFIG['editor'] || ENV['EDITOR'] || 'vim'
    system "#{editor} #{file}"
end

class Main < Thor
    desc "ruby", "Create a new ruby script"
    option :link, type: :boolean, default: false, desc: "install to the bin"
    option :edit, type: :boolean, default: true, desc: "open the script in the editor"
    def ruby(name)
        shebang = "#!/usr/bin/env ruby\n"
        path = "#{$RUBY_SCRIPTS_PATH}/#{name}.rb"

        unless File.exist? path
            File.write(path, shebang)
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
