require "system/win32api"
require "system/graphics"
require "system/input-manager"

require "scene-manager"
require "scene/intro"
require "button"

Graphics.frame_rate = 60
Graphics.resize_screen 320, 320

SceneManager.switch(Scene::Intro)

loop do
  if not SceneManager.now.nil?
    SceneManager.now.update
  end  
end