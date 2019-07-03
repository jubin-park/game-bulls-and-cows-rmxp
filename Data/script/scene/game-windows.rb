class Scene
  class Game
    def update_scroll
      delta = InputManager.wheel_delta
      return if delta == 0
      return unless InputManager.pos.x >= @viewport_list.rect.x &&
        InputManager.pos.x < @viewport_list.rect.x + @viewport_list.rect.width &&
        InputManager.pos.y >= @viewport_list.rect.y &&
        InputManager.pos.y < @viewport_list.rect.y + @viewport_list.rect.height
      @viewport_list.oy -= 10 * delta 
      if @viewport_list.oy < 0
        @viewport_list.oy = 0
      end
      max_y = Config::LIST_HEIGHT - @viewport_list.rect.height
      if @viewport_list.oy > max_y
        @viewport_list.oy = max_y
      end
      InputManager.wheel_clear
    end

    def update_drop_item
      if InputManager.mouse_trigger?(InputManager::Mouse::VK_RBUTTON)
        if @now_picked_item != nil
          i = convert_ascii_to_index(@now_picked_item)
          @sprite_item[i].x = get_first_item_pos_x(i)
          @sprite_item[i].y = get_first_item_pos_y(i)
          @now_picked_item = nil
        end
      end
    end

    def update_fade_try_button
      if @button_try.under_mouse?
        @button_try.opacity += 5
        @button_try.opacity = 255 if @button_try.opacity >= 255
      else
        @button_try.opacity -= 5
        @button_try.opacity = 128 if @button_try.opacity < 128
      end
    end

    def update
      Graphics.update
      InputManager.update
      update_phase
      @button_hole.each do |button|
        button.update
      end
      @button_try.update
      @button_try.update_bitmap
      @button_item_circle.each do |button|
        button.update
      end
      if @now_picked_item != nil
        i = convert_ascii_to_index(@now_picked_item)
        item_follow_cursor(i)
      end
      @button_previous.update
      @button_previous.update_bitmap
      update_drop_item
      update_scroll
      if @my_answer.include?(nil)
        update_hide_try_button
      else
        update_show_try_button
        update_fade_try_button
      end
    end
  end
end