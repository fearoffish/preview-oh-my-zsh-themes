#!/usr/bin/env ruby

ZSHRC_FILENAME = File.expand_path("~/.zshrc")
ZSHRC_CONTENTS = File.read(ZSHRC_FILENAME)
THEMES         = %x{ls ~/.oh-my-zsh/themes}.split(" ").collect {|t| t.gsub(".zsh-theme", "")}
ORIGINAL_THEME = ZSHRC_CONTENTS.scan(/export ZSH_THEME="(.*?)"/)[0].to_s

def change_theme_to(theme)
  File.open(ZSHRC_FILENAME, 'w') {|f| f.write(ZSHRC_CONTENTS.gsub(/export ZSH_THEME="(.*?)"/, %[export ZSH_THEME="#{theme}"])) }
end

def open_new_terminal(theme)
  new_term = <<-APPLESCRIPT
  osascript -e 'tell application "Terminal"' \\
  -e 'tell application "System Events" to tell process "Terminal" to keystroke "t" using command down' \\
  -e "do script with command \\"echo #{theme}\\" in selected tab of the front window" \\
  -e "do script with command \\"cd .oh-my-zsh\\" in selected tab of the front window" \\
  -e 'end tell' &> /dev/null
  APPLESCRIPT
  ` #{new_term}`
end

# UNCOMMENT FOR JUST 1 THEME FOR TESTING
# theme = THEMES.first
# change_theme_to(theme)
# open_new_terminal(theme)

# UNCOMMENT FOR ALL THEMES
THEMES.each do |theme|
  change_theme_to(theme)
  open_new_terminal(theme)
end

change_theme_to(ORIGINAL_THEME)