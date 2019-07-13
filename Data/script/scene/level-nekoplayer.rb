class Scene
  class Level
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