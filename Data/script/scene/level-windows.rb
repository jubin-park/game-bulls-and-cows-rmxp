class Scene
  class Level
    def m_button_digit_down
      @type_digit = (@type_digit + 1) % 5
      @type_digit = 1 if @type_digit == 0
      case @type_digit
      when 1
        Audio.se_play("sound/moo3.wav")
      when 2
        Audio.se_play("sound/moo4.wav")
      when 3
        Audio.se_play("sound/moo5.wav")
      when 4
        Audio.se_play("sound/moo6.wav")
      end
      refresh_eyeball
    end

    def m_button_range_down
      @type_range = (@type_range + 1) % 3
      refresh_eyeball
    end

    def update_play_button
      case @button_play.state_mouse
      when :down
        if @button_play_index > PLAY_BUTTON_FRAME_TAIL
          @button_play_index = PLAY_BUTTON_FRAME_TAIL
          return
        end
        @button_play.sprite.src_rect.x = @button_play_index * @button_play.width
        @button_play_index += 1
      when :up
        if @button_play_index < PLAY_BUTTON_FRAME_HEAD
          @button_play_index = PLAY_BUTTON_FRAME_HEAD
          if @button_play.state_area == :in
            @button_play.sprite.bitmap = @bitmap_play[1]
          else
            @button_play.sprite.bitmap = @bitmap_play[0]
          end
          @button_play.sprite.src_rect.x = 0
          return
        end
        @button_play.sprite.src_rect.x = @button_play_index * @button_play.width
        @button_play_index -= 1
      end
    end
  end
end