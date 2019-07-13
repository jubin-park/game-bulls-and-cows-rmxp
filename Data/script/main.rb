require "system/win32api"
require "system/graphics"
require "system/input-manager"
require "system/kernel"
require "system/user-data"

require "scene-manager"
require "scene/intro"
require "scene/level"
require "scene/game"
require "scene/result"
require "scene/play-alert"

require "ui/button"

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

$user_data = UserData.new

SceneManager.switch(Scene::Intro)

loop do
  if not SceneManager.now.nil?
    SceneManager.now.update
  end
end