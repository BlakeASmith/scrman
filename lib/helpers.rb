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

