class Scene
  class Level
    module Config
      PLAY_BUTTON_FRAME_HEAD = 0
      PLAY_BUTTON_FRAME_TAIL = 7
    end

    include Config

    def initialize
      @background = Sprite.new
      @background.bitmap = Bitmap.new("img/background2.png")
      @sprite_title = Sprite.new
      @sprite_title.bitmap = Bitmap.new(320, 32)
      @sprite_title.y = 24
      @sprite_title.bitmap.font.size = 24
      @sprite_title.bitmap.font.color = Color.new(255, 255, 255)
      #@sprite_title.bitmap.font.italic = true
      @sprite_title.bitmap.draw_text(0, 0, 320, 32, "Select Digits :)", 1)
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
      bmp_hole = Bitmap.new("img/hole.png")
      @button_digit = Button.new(32, 32) do
        {
          :x => 107,
          :y => 165,
          :bitmap =>
          [
            bmp_hole
          ]
        }
      end
      @button_digit.set_method(:button_down, method(:m_button_digit_down))
      @button_digit.set_method(:button_up, method(:m_button_digit_up))
      @button_range = Button.new(32, 32) do
        {
          :x => 178,
          :y => 165,
          :bitmap =>
          [
            bmp_hole
          ]
        }
      end
      @button_range.set_method(:button_down, method(:m_button_range_down))
      @button_range.set_method(:button_up, method(:m_button_range_up))
      @index = PLAY_BUTTON_FRAME_HEAD
    end

    def m_button_play_down
      @button_play.sprite.bitmap = @bitmap_play[2]
      @button_play.sprite.src_rect.width = @button_play.width
      @index = PLAY_BUTTON_FRAME_HEAD if @index < PLAY_BUTTON_FRAME_HEAD
    end

    def m_button_play_up
      @button_play.sprite.bitmap = @bitmap_play[2]
      @button_play.sprite.src_rect.width = @button_play.width
      @index = PLAY_BUTTON_FRAME_TAIL if @index > PLAY_BUTTON_FRAME_TAIL
    end

    def m_button_digit_down
      p "digit"
    end

    def m_button_digit_up

    end

    def m_button_range_down
      p "range"
    end

    def m_button_range_up

    end

    def update_play_button
      case @button_play.state_mouse
      when :down
        if @index > PLAY_BUTTON_FRAME_TAIL
          @index = PLAY_BUTTON_FRAME_TAIL
          return
        end
        @button_play.sprite.src_rect.x = @index * @button_play.width
        @index += 1
      when :up
        if @index < PLAY_BUTTON_FRAME_HEAD
          @index = PLAY_BUTTON_FRAME_HEAD
          if @button_play.state_area == :in
            @button_play.sprite.bitmap = @bitmap_play[1]
          else
            @button_play.sprite.bitmap = @bitmap_play[0]
          end
          @button_play.sprite.src_rect.x = 0
          return
        end
        @button_play.sprite.src_rect.x = @index * @button_play.width
        @index -= 1
      end
    end

    def update
      Graphics.update
      InputManager.update
      @button_play.update
      @button_digit.update
      @button_range.update
      update_play_button
    end
  end
end