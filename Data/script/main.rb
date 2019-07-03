require "system/win32api"
require "system/graphics"
require "system/input-manager"
require "system/kernel"

require "scene-manager"
require "scene/intro"
require "scene/level"
require "scene/game"

require "button"

module Resolution
  def self.width
    320
  end
  def self.height
    320
  end
end

Graphics.frame_rate = 60
Graphics.resize_screen Resolution.width, Resolution.height

a = [[*('0'..'9')], [*('A'..'Z')], [*('0'..'9')] + [*('A'..'Z')]]

SceneManager.switch(Scene::Game, 3, a[0])
#SceneManager.switch(Scene::Intro)

loop do
  if not SceneManager.now.nil?
    SceneManager.now.update
  end
end