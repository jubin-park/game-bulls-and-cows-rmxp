class Scene
  class Level
    def initialize
      @background = Sprite.new
      @background.bitmap = Bitmap.new("img/background2.png")
      @sprite_title = Sprite.new
      @sprite_title.bitmap = Bitmap.new(320, 32)
      @sprite_title.y = 24
      @sprite_title.bitmap.font.size = 24
      @sprite_title.bitmap.font.color = Color.new(255, 255, 255)
      #@sprite_title.bitmap.font.italic = true
      @sprite_title.bitmap.draw_text(0, 0, 320, 32, "Select Digits", 1)
      @button_play = Button.new(100, 48) do
        {
          :x => 110,
          :y => 230,
          :bitmap =>
          [
            Bitmap.new("img/button-play.png"),
            Bitmap.new("img/button-play1.png"),
            Bitmap.new("img/button-play1.png")
          ]
        }
      end
    end

    def update
      Graphics.update
      InputManager.update
      @button_play.update
    end
  end
end