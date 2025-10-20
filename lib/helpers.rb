require 'fileutils'

def ensure_dir(path)
    unless File.exist? path
        FileUtils.mkdir_p(path)
    end
end

def open_editor(file)
    editor = $CONFIG.editor
    system "#{editor} #{file}"
end

def find_language(name)
    $languages[name] || $languages_by_extension[name] || $languages[$CONFIG.default_language]
end

def find_script(name, lang_filter = nil)
    # Find the script across all languages or specific language
    script_found = false
    script_path = nil
    script_lang = nil
    
    if lang_filter
        # Look in specific language directory
        lang_config = $CONFIG.languages[lang_filter]
        if lang_config
            lang = Language.new(lang_filter, lang_config['extension'])
            path = lang.path(name)
            if File.exist?(path)
                script_found = true
                script_path = path
                script_lang = lang_filter
            end
        end
    else
        # Search across all language directories
        Dir.glob(File.join($SCRIPTS_PATH, '*')).each do |lang_dir|
            next unless File.directory?(lang_dir)
            
            lang_name = File.basename(lang_dir)
            lang_config = $CONFIG.languages[lang_name]
            next unless lang_config
            
            extension = lang_config['extension']
            path = File.join(lang_dir, "#{name}.#{extension}")
            
            if File.exist?(path)
                script_found = true
                script_path = path
                script_lang = lang_name
                break
            end
        end
    end
    
    {
        found: script_found,
        path: script_path,
        language: script_lang
    }
end

