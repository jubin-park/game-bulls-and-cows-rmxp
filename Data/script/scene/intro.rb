class Scene
  class Intro
    def initialize
      @background = Sprite.new
      @background.bitmap = Bitmap.new(640, 320)
      @background.bitmap.blt(0, 0, Bitmap.new("img/background.png"), Rect.new(0, 0, 320, 320))
      @background.bitmap.blt(320, 0, Bitmap.new("img/background2.png"), Rect.new(0, 0, 320, 320))
      @logo = Array.new(5) {Sprite.new}
      @logo.each do |spr|
        spr.ox = 160
        spr.oy = 160
        spr.x = 160
        spr.y = 128
      end
      @logo[0].opacity = 0
      @logo[0].bitmap = Bitmap.new("img/logo0.png")
      @logo[0].z = 1
      @logo[1].opacity = 0
      @logo[1].bitmap = Bitmap.new("img/logo1.png")
      @logo[1].z = 1
      @logo[2].opacity = 0
      @logo[2].bitmap = Bitmap.new("img/logo2.png")
      @logo[2].z = 1
      @logo[3].opacity = 0
      @logo[3].bitmap = Bitmap.new("img/logo3.png")
      @logo[3].z = 0
      @logo[4].bitmap = Bitmap.new("img/logo.png")
      @logo[4].z = 1
      @logo[4].visible = false
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
      @button_start.z = 2
      @button_start.set_method(:button_down, method(:m_button_start_down))
      @button_start.set_method(:button_up, method(:m_button_start_up))
      @button_start.opacity = 0
      @phase = 0
    end

    def dispose
      @background.bitmap.dispose
      @background.dispose
      for i in 0...5
        @logo[i].bitmap.dispose
        @logo[i].dispose
      end
      @button_start.dispose
    end

    def m_button_start_up
      @phase = 10
    end

    def m_button_start_down
    end

    def update
      Graphics.update
      InputManager.update
      @button_start.update
      @button_start.update_bitmap
      update_phase
    end

    def update_phase
      case @phase
      when 0
        @scale *= 0.96
        @scale = 1.0 if @scale < 1.0
        @logo[0].zoom_x = @logo[0].zoom_y = @scale
        @logo[0].opacity += 3
        @logo[0].opacity = 255 if @logo[0].opacity > 255
        return if @scale != 1.0
        return if @logo[0].opacity != 255
        @phase = 1
      when 1
        @logo[0].opacity -= 5
        @logo[0].opacity = 0 if @logo[0].opacity < 0
        @logo[1].opacity += 10
        @logo[1].opacity = 255 if @logo[1].opacity > 255
        return if @logo[0].opacity != 0
        return if @logo[1].opacity != 255
        Audio.se_play("sound/intro.wav")
        @phase = 2
      when 2
        @logo[2].opacity += 5
        @logo[2].opacity = 255 if @logo[2].opacity > 255
        return if @logo[2].opacity != 255
        @phase = 3
      when 3
        @logo[3].opacity += 10
        @logo[3].opacity = 255 if @logo[3].opacity > 255
        return if @logo[3].opacity != 255
        @phase = 4
      when 4
        @button_start.opacity += 8
        @button_start.opacity = 255 if @button_start.opacity > 255
        return if @button_start.opacity != 255
        @phase = 5
      when 5
        for i in 0...4
          @logo[i].visible = false
        end
        @logo[4].visible = true
        @phase = -1
      when 10
        for i in 0...4
          @logo[i].visible = false
        end
        @logo[4].visible = true
        @phase = 11
      when 11
        @logo[4].opacity -= 10
        @logo[4].opacity = 0 if @logo[4].opacity < 0
        @button_start.opacity -= 10
        @button_start.opacity = 0 if @button_start.opacity < 0
        return if @logo[4].opacity != 0
        return if @button_start.opacity != 0
        @phase = 12
      when 12
        @background.x -= ((320 - @background.x.abs) * 0.1).ceil
        if @background.x <= -320
          @background.x = -320
          @phase = 13
        end
      when 13
        dispose
        SceneManager.switch(Scene::Level)
      end
    end
  end
end