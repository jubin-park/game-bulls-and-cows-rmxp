class Scene
  class Intro
    module EyeBall
      X = [75, 94, 226, 249]
      Y = [156 - 32, 156 - 32, 155- 32, 158 - 32]
      #X = [76, 95, 222, 245]
      #Y = [154 - 32, 154 - 32, 152 - 32, 154 - 32]
      RADIUS = [3, 3, 5, 5]
    end

    def initialize(*args)
      @sprite_eye = Array.new(4) {Sprite.new}
      @sprite_eye.each do |spr|
        spr.bitmap = Bitmap.new(3, 4)
        spr.bitmap.fill_rect(0, 0, 3, 4, Color.new(0, 0, 0))
        spr.opacity = 0
        spr.z = 2
      end
      @sprite_eye.each_index do |i|
        @sprite_eye[i].x = EyeBall::X[i]
        @sprite_eye[i].y = EyeBall::Y[i]
      end
      @sprite_background = Sprite.new
      @sprite_background.bitmap = Bitmap.new(640, 320)
      @sprite_background.bitmap.blt(0, 0, Bitmap.new("img/background.png"), Rect.new(0, 0, 320, 320))
      @sprite_background.bitmap.blt(320, 0, Bitmap.new("img/background2.png"), Rect.new(0, 0, 320, 320))
      @sprite_logo = Array.new(5) {Sprite.new}
      @sprite_logo.each do |spr|
        spr.ox = 160
        spr.oy = 160
        spr.x = 160
        spr.y = 128
      end
      @sprite_logo[0].opacity = 0
      @sprite_logo[0].bitmap = Bitmap.new("img/logo0.png")
      @sprite_logo[0].z = 1
      @sprite_logo[1].opacity = 0
      @sprite_logo[1].bitmap = Bitmap.new("img/logo1.png")
      @sprite_logo[1].z = 1
      @sprite_logo[2].opacity = 0
      @sprite_logo[2].bitmap = Bitmap.new("img/logo2.png")
      @sprite_logo[2].z = 1
      @sprite_logo[3].opacity = 0
      @sprite_logo[3].bitmap = Bitmap.new("img/logo3.png")
      @sprite_logo[3].z = 0
      @sprite_logo[4].bitmap = Bitmap.new("img/logo.png")
      @sprite_logo[4].z = 1
      @sprite_logo[4].visible = false
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
      @sprite_background.bitmap.dispose
      @sprite_background.dispose
      @sprite_logo.each do |spr|
        spr.bitmap.dispose
        spr.dispose
      end
      @sprite_eye.each do |spr|
        spr.bitmap.dispose
        spr.dispose
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
      update_eyeball
    end

    def update_eyeball
      return if InputManager.pos.x.nil?
      return if @phase >= 13
      for i in 0...4
        ox = EyeBall::X[i]
        oy = EyeBall::Y[i]
        r = EyeBall::RADIUS[i]
        rad = Math.atan2(oy - InputManager.pos.y, ox - InputManager.pos.x) * (180 / Math::PI) + 180
        @sprite_eye[i].x = ox + r * Math.cos(rad * Math::PI / 180)
        @sprite_eye[i].y = oy + r * Math.sin(rad * Math::PI / 180)      
      end
    end

    def update_phase
      case @phase
      when 0
        @scale *= 0.96
        @scale = 1.0 if @scale < 1.0
        @sprite_logo[0].zoom_x = @sprite_logo[0].zoom_y = @scale
        @sprite_logo[0].opacity += 3
        @sprite_logo[0].opacity = 255 if @sprite_logo[0].opacity > 255
        return if @scale != 1.0
        return if @sprite_logo[0].opacity != 255
        @phase = 1
      when 1
        @sprite_logo[0].opacity -= 5
        @sprite_logo[0].opacity = 0 if @sprite_logo[0].opacity < 0
        @sprite_logo[1].opacity += 10
        @sprite_logo[1].opacity = 255 if @sprite_logo[1].opacity > 255
        return if @sprite_logo[0].opacity != 0
        return if @sprite_logo[1].opacity != 255
        Audio.se_play("sound/intro.wav")
        @phase = 2
      when 2
        @sprite_logo[2].opacity += 5
        @sprite_eye.each do |spr|
          spr.opacity += 5
          spr.opacity = 255 if spr.opacity > 255
        end
        @sprite_logo[2].opacity = 255 if @sprite_logo[2].opacity > 255
        return if @sprite_logo[2].opacity != 255
        @phase = 3
      when 3
        @sprite_logo[3].opacity += 10
        @sprite_logo[3].opacity = 255 if @sprite_logo[3].opacity > 255
        return if @sprite_logo[3].opacity != 255
        @phase = 4
      when 4
        @button_start.opacity += 8
        @button_start.opacity = 255 if @button_start.opacity > 255
        return if @button_start.opacity != 255
        @phase = 5
      when 5
        @sprite_logo.each do |spr|
          spr.visible = false
        end
        @sprite_logo[4].visible = true
        @phase = -1
      when 10
        @sprite_logo.each do |spr|
          spr.visible = false
        end
        @sprite_logo[4].visible = true
        @phase = 11
      when 11
        @sprite_logo[4].opacity -= 10
        @sprite_logo[4].opacity = 0 if @sprite_logo[4].opacity < 0
        @button_start.opacity -= 10
        @button_start.opacity = 0 if @button_start.opacity < 0
        @sprite_eye.each do |spr|
          spr.opacity -= 10
          spr.opacity = 0 if spr.opacity < 0
        end
        return if @sprite_logo[4].opacity != 0
        return if @button_start.opacity != 0
        return if @sprite_eye[0].opacity != 0
        @phase = 12
      when 12
        @sprite_background.x -= ((320 - @sprite_background.x.abs) * 0.1).ceil
        if @sprite_background.x <= -320
          @sprite_background.x = -320
          @phase = 13
        end
      when 13
        dispose
        SceneManager.switch(Scene::Level)
      end
    end
  end
end