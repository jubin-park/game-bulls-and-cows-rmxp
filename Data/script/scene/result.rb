class Scene
  class Result
    def initialize(*args)
      args = *args
      final = args[0]
      @phase = 0
      @viewport_window = Viewport.new(0, 0, 320, 320)
      @viewport_window.z = 10
      @sprite_window = Sprite.new(@viewport_window)
      @sprite_window.opacity = 0
      @sprite_window.bitmap = Bitmap.new(320, 320)
      @sprite_window.bitmap.fill_rect(0, 0, 320, 320, Color.new(0, 0, 0, 224))
      @sprite_text = Sprite.new(@viewport_window)
      @sprite_text.opacity = 0
      @sprite_text.bitmap = Bitmap.new(320, 320)
      @sprite_text.bitmap.font.italic = true
      @sprite_text.bitmap.draw_text(0, 32, 320, 32, "#{final[2]} Bulls Clear !", 1)
      @sprite_text.bitmap.font.italic = false
      @sprite_text.bitmap.font.size = 16
      @sprite_text.bitmap.font.color = Color.new(192, 192, 192)
      @sprite_text.bitmap.draw_text(40, 80, 120, 32, "Answer is")
      @sprite_text.bitmap.draw_text(40, 112, 120, 32, "Tried Count is")
      @sprite_text.bitmap.font.italic = true
      @sprite_text.bitmap.font.size = 24
      @sprite_text.bitmap.font.color = Color.new(255, 255, 255)
      @sprite_text.bitmap.draw_text(160, 80, 120, 32, final[1].join('.'), 2)
      @sprite_text.bitmap.draw_text(160, 112, 120, 32, final[0].to_s, 2)
      @button_replay = Button.new(128, 48, @viewport_window) do
        {
          :x => 96,
          :y => 165,
          :bitmap =>
          [
            Bitmap.new("img/button-replay0.png"),
            Bitmap.new("img/button-replay1.png"),
            Bitmap.new("img/button-replay2.png")
          ],
        }
      end
      @button_replay.opacity = 0
      @button_replay.set_method(:button_up, method(:m_button_replay_up))
      @button_exit = Button.new(128, 48, @viewport_window) do
        {
          :x => 96,
          :y => 215,
          :bitmap =>
          [
            Bitmap.new("img/button-exit0.png"),
            Bitmap.new("img/button-exit1.png"),
            Bitmap.new("img/button-exit2.png")
          ],
        }
      end
      @button_exit.opacity = 0
      @button_exit.set_method(:button_up, method(:m_button_exit_up))
    end
    
    def dispose
      @viewport_window.dispose
      @sprite_window.bitmap.dispose
      @sprite_window.dispose
      @sprite_text.bitmap.dispose
      @sprite_text.dispose
      @button_replay.dispose
      @button_exit.dispose
    end

    def m_button_replay_up
      return if @phase == 0
      $user_data.last_used.log = []
      $user_data.save
      SceneManager.previous.dispose
      dispose
      SceneManager.switch(Scene::Game, 
        Scene::Level::Config::LEVEL_DIGIT[$user_data.last_used.digit],
        Scene::Level::Config::LEVEL_RANGE[$user_data.last_used.range])
      
    end

    def m_button_exit_up
      return if @phase == 0
      $user_data.last_used.log = []
      $user_data.save
      SceneManager.previous.dispose
      dispose
      SceneManager.switch(Scene::Level)
    end   

    def update_phase
      case @phase
      when 0
        @sprite_window.opacity += 5
        @sprite_window.opacity = 255 if @sprite_window.opacity > 255
        @sprite_text.opacity += 5
        @sprite_text.opacity = 255 if @sprite_text.opacity > 255
        @button_replay.opacity += 5
        @button_replay.opacity = 255 if @button_replay.opacity > 255
        @button_exit.opacity += 5
        @button_exit.opacity = 255 if @button_exit.opacity > 255
        return if @sprite_window.opacity != 255
        return if @sprite_text.opacity != 255
        return if @button_replay.opacity != 255
        return if @button_exit.opacity != 255
        @phase = -1
      end
    end

    def update
      Graphics.update
      InputManager.update
      @button_replay.update
      @button_replay.update_bitmap
      @button_exit.update
      @button_exit.update_bitmap
      update_phase
    end
  end
end