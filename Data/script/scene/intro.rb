class Scene
  class Intro
    def initialize
      @background = Sprite.new
      @background.bitmap = Bitmap.new("img/background.png")
      @logo = Sprite.new
      @logo.opacity = 0
      @logo.bitmap = Bitmap.new("img/logo.png")
      @logo.ox = 160
      @logo.oy = 160
      @logo.x = 160
      @logo.y = 160
      @scale = 2.0
    end

    def update
      Graphics.update
      InputManager.update
      update_scaled_logo
    end

    def update_scaled_logo
      @scale *= 0.95
      @scale = 1.0 if @scale < 1
      @logo.zoom_x = @logo.zoom_y = @scale
      @logo.opacity += 10
      @logo.opacity = 255 if @logo.opacity > 255
    end
  end
end