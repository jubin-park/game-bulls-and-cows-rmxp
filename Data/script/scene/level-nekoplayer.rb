class Scene
  class Level
    def m_button_digit_down
      @type_digit = (@type_digit + 1) % 5
      if @type_digit == 0
        @type_range = 3
      else
        if @type_range == 3
          @type_range = 0
        end
      end
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
      if @type_digit == 0
        @type_range = 3
      else
        @type_range = (@type_range + 1) % 3
      end
      refresh_eyeball
    end

    def update_play_button
      if @button_play.under_touch_first?
        if @button_play.under_touch?
          if @button_play_index > PLAY_BUTTON_FRAME_TAIL
            @button_play_index = PLAY_BUTTON_FRAME_TAIL
            return
          end
          @button_play_index = PLAY_BUTTON_FRAME_HEAD if @button_play_index < PLAY_BUTTON_FRAME_HEAD
          @button_play.sprite.bitmap = @bitmap_play[2]
          @button_play.sprite.src_rect.x = @button_play_index * @button_play.width
          @button_play_index += 1
        else
          if @button_play_index < PLAY_BUTTON_FRAME_HEAD
            @button_play_index = PLAY_BUTTON_FRAME_HEAD
            @button_play.sprite.src_rect.x = 0
            @button_play.sprite.bitmap = @bitmap_play[0]
            return
          end
          @button_play_index = PLAY_BUTTON_FRAME_TAIL if @button_play_index > PLAY_BUTTON_FRAME_TAIL
          @button_play.sprite.src_rect.x = @button_play_index * @button_play.width
          @button_play_index -= 1
        end
      else
        if @button_play.under_touch?
          @button_play.sprite.src_rect.x = 0
          @button_play.sprite.bitmap = @bitmap_play[1]
        else
          if @button_play_index < PLAY_BUTTON_FRAME_HEAD
            @button_play_index = PLAY_BUTTON_FRAME_HEAD
            @button_play.sprite.src_rect.x = 0
            @button_play.sprite.bitmap = @bitmap_play[0]
            return
          end
          @button_play_index = PLAY_BUTTON_FRAME_TAIL if @button_play_index > PLAY_BUTTON_FRAME_TAIL
          @button_play.sprite.src_rect.x = @button_play_index * @button_play.width
          @button_play_index -= 1
        end
      end
    end
  end
end