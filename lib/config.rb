require 'yaml'
require 'fileutils'
require_relative 'helpers'

$CONFIG_PATH = File.join(ENV['HOME'], '.scrman', 'config.yml')
$SCRIPTS_PATH = File.join(ENV['HOME'], '.scrman', 'scripts')

ensure_dir($SCRIPTS_PATH)

unless File.exist?($CONFIG_PATH)
    FileUtils.mkdir_p(File.dirname($CONFIG_PATH))
    File.write($CONFIG_PATH, { 
        'version' => '0.0.1',
        'editor' => 'vim',
        'bin' => File.join(ENV['HOME'], '.local', 'bin'),
        'languages' => {
            'ruby' => {
                'interpreter' => 'ruby'
            },
            'python' => {
                'interpreter' => 'python'
            },
            'javascript' => {
                'interpreter' => 'node'
            },
            'typescript' => {
                'interpreter' => 'bun run'
            },
            'bash' => {
                'interpreter' => 'bash'
            },
            'zsh' => {
                'interpreter' => 'zsh'
            }
        },
        'default_language' => 'ruby'
    }.to_yaml)
end

class Config
    def initialize(path)
        @config = YAML.load_file(path)
    end

    def interpreter(language)
        return @config['languages'][language]['interpreter']
    end

    def bin
        return @config['bin']
    end

    def editor
        return @config['editor'] || ENV['EDITOR'] || 'vim'
    end

    def default_language
        return @config['default_language']
    end
end

$CONFIG = Config.new($CONFIG_PATH)
$BIN = $CONFIG.bin

