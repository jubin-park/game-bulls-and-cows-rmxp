class Scene
  class PlayAlert
    def initialize(*args)
      args = *args
      @select_digit, @select_range = args[0], args[1]
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
      @sprite_text.bitmap.font.size = if $NEKO_RUBY.nil?
        22
      else
        18
      end
      @sprite_text.bitmap.draw_text(0, 40, 320, 32, "Game is already in progress...", 1)
      @button_newgame = Button.new(128, 48, @viewport_window) do
        {
          :x => 96,
          :y => 115,
          :bitmap =>
          [
            Bitmap.new("img/button-newgame0.png"),
            Bitmap.new("img/button-newgame1.png"),
            Bitmap.new("img/button-newgame2.png")
          ],
        }
      end
      @button_newgame.opacity = 0
      @button_newgame.set_method(:button_up, method(:m_button_newgame_up))
      @button_continue = Button.new(128, 48, @viewport_window) do
        {
          :x => 96,
          :y => 165,
          :bitmap =>
          [
            Bitmap.new("img/button-continue0.png"),
            Bitmap.new("img/button-continue1.png"),
            Bitmap.new("img/button-continue2.png")
          ],
        }
      end
      @button_continue.opacity = 0
      @button_continue.set_method(:button_up, method(:m_button_continue_up))
      @button_shutdown = Button.new(128, 48, @viewport_window) do
        {
          :x => 96,
          :y => 215,
          :bitmap =>
          [
            Bitmap.new("img/button-shutdown0.png"),
            Bitmap.new("img/button-shutdown1.png"),
            Bitmap.new("img/button-shutdown2.png")
          ],
        }
      end
      @button_shutdown.opacity = 0
      @button_shutdown.set_method(:button_up, method(:m_button_shutdown_up))
    end
    
    def dispose
      @viewport_window.dispose
      @sprite_window.bitmap.dispose
      @sprite_window.dispose
      @sprite_text.bitmap.dispose
      @sprite_text.dispose
      @button_newgame.dispose
      @button_continue.dispose
      @button_shutdown.dispose
    end

    def m_button_newgame_up
      return if @phase >= 0
      @phase = 10
    end

    def m_button_continue_up
      return if @phase >= 0
      @phase = 20
    end

    def m_button_shutdown_up
      return if @phase >= 0
      @phase = 30
    end   

    def fadeout_ended
      @sprite_window.opacity -= 10
      @sprite_text.opacity -= 10
      @button_newgame.opacity -= 10
      @button_continue.opacity -= 10
      @button_shutdown.opacity -= 10
      return if @sprite_window.opacity != 0
      return if @sprite_text.opacity != 0
      return if @button_newgame.opacity != 0
      return if @button_continue.opacity != 0
      return if @button_shutdown.opacity != 0
      return true
    end

    def update_phase
      case @phase
      when 0
        @sprite_window.opacity += 5
        @sprite_text.opacity += 5
        @button_newgame.opacity += 5
        @button_continue.opacity += 5
        @button_shutdown.opacity += 5
        return if @sprite_window.opacity != 255
        return if @sprite_text.opacity != 255
        return if @button_newgame.opacity != 255
        return if @button_continue.opacity != 255
        return if @button_shutdown.opacity != 255
        @phase = -1
      when 10
        return if not fadeout_ended
        @phase = 11
      when 11
        $user_data.last_used.digit = @select_digit
        $user_data.last_used.range = @select_range
        $user_data.last_used.my_answer = []
        $user_data.last_used.real_answer = []
        $user_data.last_used.log = []
        $user_data.save
        SceneManager.previous.dispose
        dispose
        SceneManager.switch(Scene::Game, 
          Scene::Level::Config::LEVEL_DIGIT[@select_digit],
          Scene::Level::Config::LEVEL_RANGE[@select_range])
      when 20
        return if not fadeout_ended
        @phase = 21
      when 21
        SceneManager.previous.dispose
        dispose
        SceneManager.switch(Scene::Game, 
          Scene::Level::Config::LEVEL_DIGIT[$user_data.last_used.digit],
          Scene::Level::Config::LEVEL_RANGE[$user_data.last_used.range])
      when 30
        return if not fadeout_ended
        @phase = 31
      when 31
        dispose
        SceneManager.now = SceneManager.previous
      end
    end

    def update
      Graphics.update
      InputManager.update
      @button_newgame.update
      @button_newgame.update_bitmap
      @button_continue.update
      @button_continue.update_bitmap
      @button_shutdown.update
      @button_shutdown.update_bitmap
      update_phase
    end
  end
end