class Scene
  class Intro
    def initialize
      Audio.se_play("sound/intro.wav")
      @background = Sprite.new
      @background.bitmap = Bitmap.new(640, 320)
      @background.bitmap.blt(0, 0, Bitmap.new("img/background.png"), Rect.new(0, 0, 320, 320))
      @background.bitmap.blt(320, 0, Bitmap.new("img/background2.png"), Rect.new(0, 0, 320, 320))
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
      @phase = 0
    end

    def dispose
      @background.bitmap.dispose
      @background.dispose
      @logo.bitmap.dispose
      @logo.dispose
      @button_start.dispose
    end

    def m_button_start_up
      @phase = 1
    end

    def m_button_start_down
    end

    def update
      Graphics.update
      InputManager.update
      @button_start.update
      update_phase
    end

    def update_phase
      case @phase
      when 0
        @scale *= 0.95
        @scale = 1.0 if @scale < 1.0
        @logo.zoom_x = @logo.zoom_y = @scale
        @logo.opacity += 2
        @logo.opacity = 255 if @logo.opacity > 255
        return if @scale != 1.0
        return if @logo.opacity != 255
        @phase = -1
      when 1
        @logo.opacity -= 10
        @button_start.opacity -= 10
        @logo.opacity = 0 if @logo.opacity < 0
        @button_start.opacity = 0 if @button_start.opacity < 0
        return if @logo.opacity != 0
        return if @button_start.opacity != 0
        @phase = 2
      when 2
        @background.x -= ((320 - @background.x.abs) * 0.1).ceil
        if @background.x <= -320
          @background.x = -320
          @phase = 3
        end
      when 3
        dispose
        SceneManager.switch(Scene::Level)
      end
    end
  end
end