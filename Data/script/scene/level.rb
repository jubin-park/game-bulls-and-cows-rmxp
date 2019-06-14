class Scene
  class Level
    def initialize
      @background = Sprite.new
      @background.bitmap = Bitmap.new("img/background.png")
      @sprite_title = Sprite.new
      @sprite_title.bitmap = Bitmap.new(320, 24)
      @sprite_title.y = 24
      @sprite_title.bitmap.font.size = 24
      @sprite_title.bitmap.font.color = Color.new(255, 255, 255)
      @sprite_title.bitmap.font.italic = true
      @sprite_title.bitmap.draw_text(@sprite_title.src_rect, "Select Digits", 1)
    end

    def update
      Graphics.update
      InputManager.update
    end
  end
end