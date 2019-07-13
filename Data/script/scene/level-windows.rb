class Scene
  class Level
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