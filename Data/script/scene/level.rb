class Scene
  class Level
    module Config
      PLAY_BUTTON_FRAME_HEAD = 0
      PLAY_BUTTON_FRAME_TAIL = 7
      LEVEL_DIGIT = [3, 4, 5, 6]
      LEVEL_RANGE = [[*('0'..'9')], [*('A'..'Z')], [*('0'..'9')] + [*('A'..'Z')]]
    end

    include Config

    def initialize(*args)
      @type_digit = $user_data.last_used.digit
      @type_range = $user_data.last_used.range
      @phase = -1
      @sprite_background = Sprite.new
      @sprite_background.bitmap = Bitmap.new("img/background2.png")
      @sprite_black = Sprite.new
      @sprite_black.bitmap = Bitmap.new(320, 320)
      @sprite_black.bitmap.fill_rect(0, 0, 320, 320, Color.new(0, 0, 0))
      @sprite_black.opacity = 0
      @sprite_black.z = 10
      @sprite_title = Sprite.new
      @sprite_title.bitmap = Bitmap.new(320, 32)
      @sprite_title.y = 24
      @sprite_title.bitmap.font.size = 24
      @sprite_title.bitmap.font.color = Color.new(255, 255, 255)
      @sprite_title.bitmap.draw_text(0, 0, 320, 32, "Choose Level", 1)
      @sprite_ground = Sprite.new
      @sprite_ground.bitmap = Bitmap.new("img/ground.png")
      @sprite_ground.x = 110
      @sprite_ground.y = 230
      @sprite_label_digit = Sprite.new
      @sprite_label_digit.bitmap = Bitmap.new("img/label_digits.png")
      @sprite_label_digit.x = 104
      @sprite_label_digit.y = 145
      @sprite_label_range = Sprite.new
      @sprite_label_range.bitmap = Bitmap.new("img/label_ranges.png")
      @sprite_label_range.x = 173
      @sprite_label_range.y = 145
      @sprite_digit = Sprite.new
      @sprite_digit.bitmap = Bitmap.new(80, 16)
      @sprite_digit.bitmap.blt(0, 0, Bitmap.new("img/numbers.png"), Rect.new(48, 0, 64, 16))
      @sprite_digit.src_rect.width = 16
      @sprite_digit.x = 116
      @sprite_digit.y = 173
      @sprite_digit.z = 1
      @sprite_range = Sprite.new
      @sprite_range.bitmap = Bitmap.new("img/range.png")
      @sprite_range.src_rect.width = 24
      @sprite_range.x = 183
      @sprite_range.y = 169
      @sprite_range.z = 1
      @bitmap_play = [
        Bitmap.new("img/button-play0.png"),
        Bitmap.new("img/button-play1.png"),
        Bitmap.new("img/button-play2-spriteset.png")
      ]
      @button_play = Button.new(100, 48) do
        {
          :x => 110,
          :y => 230,
          :bitmap => @bitmap_play
        }
      end
      @button_play.set_method(:button_down, method(:m_button_play_down))
      @button_play.set_method(:button_up, method(:m_button_play_up))
      bmp_hole = Bitmap.new("img/eyeball.png")
      @button_digit = Button.new(34, 34) do
        {
          :x => 107,
          :y => 165,
          :bitmap => [bmp_hole]
        }
      end
      @button_digit.set_method(:button_down, method(:m_button_digit_down))
      @button_digit.set_method(:button_up, method(:m_button_digit_up))
      @button_range = Button.new(34, 34) do
        {
          :x => 178,
          :y => 165,
          :bitmap => [bmp_hole]
        }
      end
      @button_range.set_method(:button_down, method(:m_button_range_down))
      @button_range.set_method(:button_up, method(:m_button_range_up))
      @button_play_index = PLAY_BUTTON_FRAME_HEAD
      refresh_eyeball
    end

    def dispose
      @button_play.dispose
      @bitmap_play.each do |bmp|
        bmp.dispose
      end
      @button_digit.dispose
      @button_range.dispose
      @sprite_background.bitmap.dispose
      @sprite_background.dispose
      @sprite_ground.bitmap.dispose
      @sprite_ground.dispose
      @sprite_label_digit.bitmap.dispose
      @sprite_label_digit.dispose
      @sprite_label_range.bitmap.dispose
      @sprite_label_range.dispose
      @sprite_title.bitmap.dispose
      @sprite_title.dispose
      @sprite_digit.bitmap.dispose
      @sprite_digit.dispose
      @sprite_range.bitmap.dispose
      @sprite_range.dispose
      @sprite_black.bitmap.dispose
      @sprite_black.dispose
    end

    def m_button_digit_down
      @type_digit = (@type_digit + 1) % 4
      case @type_digit
      when 0
        Audio.se_play("sound/moo3.wav")
      when 1
        Audio.se_play("sound/moo4.wav")
      when 2
        Audio.se_play("sound/moo5.wav")
      when 3
        Audio.se_play("sound/moo6.wav")
      end
      refresh_eyeball
    end

    def m_button_range_down
      @type_range = (@type_range + 1) % 3
      refresh_eyeball
    end

    def m_button_play_down
      @button_play.sprite.bitmap = @bitmap_play[2]
      @button_play.sprite.src_rect.width = @button_play.width
      @button_play_index = PLAY_BUTTON_FRAME_HEAD if @button_play_index < PLAY_BUTTON_FRAME_HEAD
    end

    def m_button_play_up
      @button_play.sprite.bitmap = @bitmap_play[2]
      @button_play.sprite.src_rect.width = @button_play.width
      @button_play_index = PLAY_BUTTON_FRAME_TAIL if @button_play_index > PLAY_BUTTON_FRAME_TAIL
      if $user_data.last_used.log.size > 0
        SceneManager.switch(Scene::PlayAlert, @type_digit, @type_range)
      else
        @phase = 0
        $user_data.last_used.digit = @type_digit
        $user_data.last_used.range = @type_range
        $user_data.save
      end
    end

    def m_button_digit_up

    end

    def m_button_range_up

    end

    def refresh_eyeball
      @sprite_digit.src_rect.x = @type_digit * 16
      @sprite_range.src_rect.x = @type_range * 24
    end

    def update_label
      @sprite_label_digit.y = 145 + (Graphics.frame_count / 15) % 2
      @sprite_label_range.y = 145 + (Graphics.frame_count / 15) % 2
    end

    def update_phase
      case @phase
      when 0
        @sprite_black.opacity += 5
        @sprite_black.opacity = 255 if @sprite_black.opacity > 255
        return if @sprite_black.opacity != 255
        @phase = 1
      when 1
        @sprite_background.x -= ((320 - @sprite_background.x.abs) * 0.1).ceil
        if @sprite_background.x <= -320
          @sprite_background.x = -320
          @phase = 2
        end
      when 2
        dispose
        SceneManager.switch(Scene::Game, LEVEL_DIGIT[@type_digit], LEVEL_RANGE[@type_range])
      end
    end

    def update
      Graphics.update
      InputManager.update
      @button_play.update
      @button_digit.update
      @button_range.update
      update_play_button
      update_label
      update_phase
    end
  end
end

if $NEKO_RUBY.nil?
  require "scene/level-windows"
else
  require "scene/level-nekoplayer"
end