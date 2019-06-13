if $NEKO_RUBY.nil?
  require "system/input-manager-windows"
else
  require "system/input-manager-nekoplayer"
end