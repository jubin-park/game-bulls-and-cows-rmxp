class Scene
  class Intro
    def initialize
      Audio.se_play("sound/intro.wav")
      @background = Sprite.new
      @background.bitmap = Bitmap.new("img/background.png")
      @logo = Sprite.new
      @logo.opacity = 0
      @logo.bitmap = Bitmap.new("img/logo.png")
      @logo.ox = 160
      @logo.oy = 160
      @logo.x = 160
      @logo.y = 128
      @scale = 3.0
      @button_start = Button.new(128, 48) do
        {
          :x => 96,
          :y => 196,
          :bitmap =>
          [
            Bitmap.new("img/button-start0.png"),
            Bitmap.new("img/button-start1.png"),
            Bitmap.new("img/button-start2.png")
          ]
        }
      end
      @button_start.z = 1
      @button_start.set_method(:button_down, method(:m_button_start_down))
      @button_start.set_method(:button_up, method(:m_button_start_up))
    end

    def dispose
      @background.bitmap.dispose
      @background.dispose
      @logo.bitmap.dispose
      @logo.dispose
      @button_start.dispose
    end

    def m_button_start_up
      dispose
      SceneManager.switch(Scene::Level)
    end

    def m_button_start_down
    end

    def update
      Graphics.update
      InputManager.update
      update_scaled_logo
      @button_start.update
    end

    def update_scaled_logo
      @scale *= 0.95
      @scale = 1.0 if @scale < 1.0
      @logo.zoom_x = @logo.zoom_y = @scale
      @logo.opacity += 2
      @logo.opacity = 255 if @logo.opacity > 255
    end


  end
end