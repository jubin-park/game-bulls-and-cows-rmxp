class Scene
  class Game
    def draw_log(y, count, answer, bull, cow)
      @sprite_list.bitmap.font.color = if bull == @digit
        Color.new(255, 255, 0)
      else
        Color.new(255, 255, 255)
      end
      @sprite_list.bitmap.font.bold = false
      @sprite_list.bitmap.draw_text(4, y, 36, Config::LIST_HEIGHT_PER_LINE, sprintf("%03d", count))
      @sprite_list.bitmap.font.bold = true
      @sprite_list.bitmap.draw_text(34, y, 82, Config::LIST_HEIGHT_PER_LINE, answer.join("."), 1)
      x = @viewport_list.rect.width - 2
      for i in 0...cow
        x -= 22
        @sprite_list.bitmap.blt(x, y, @bitmap_cow, Rect.new(0, 0, 24, 24))
      end
      for i in 0...bull
        x -= 22
        @sprite_list.bitmap.blt(x, y, @bitmap_bull, Rect.new(0, 0, 24, 24))
      end
    end

    def m_button_hole_down(hole_index)
      # when item is already picked
      if @now_picked_item != nil
        old_item = @my_answer[hole_index]
        # when item in hole is already existed
        if old_item != nil
          i = convert_ascii_to_index(old_item)
          @sprite_item[i].x = 2 + get_first_item_pos_x(i)
          @sprite_item[i].y = 2 + get_first_item_pos_y(i)
        end
        i = convert_ascii_to_index(@now_picked_item)
        @sprite_item[i].x = get_inhole_item_pos_x(hole_index)
        @sprite_item[i].y = get_inhole_item_pos_y(hole_index)
        @my_answer[hole_index] = @now_picked_item
      else
        old_item = @my_answer[hole_index]
        # when item in hole is already existed
        if old_item != nil
          i = convert_ascii_to_index(old_item)
          @sprite_item[i].x = 2 + get_first_item_pos_x(i)
          @sprite_item[i].y = 2 + get_first_item_pos_y(i)
          @my_answer[hole_index] = nil
        end
      end
      @now_picked_item = nil
    end

    def m_button_hole_up(hole_index)

    end

    def m_button_item_down(index)
      
    end

    def m_button_item_up(index)
      if @now_picked_item != nil
        i = convert_ascii_to_index(@now_picked_item)
        @sprite_item[i].x = 2 + get_first_item_pos_x(i)
        @sprite_item[i].y = 2 + get_first_item_pos_y(i)
      end
      item = convert_index_to_ascii(index)
      if not @my_answer.include?(item)
        @now_picked_item = item
      end
    end

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
      if InputManager.mouse_press?(InputManager::Mouse::VK_LBUTTON)
        failed = true
        @button_hole.each do |button|
          if button.under_mouse?
            failed = false
          end
        end
      elsif InputManager.mouse_trigger?(InputManager::Mouse::VK_RBUTTON)
        failed = true
      end
      if failed == true
        if @now_picked_item != nil
          i = convert_ascii_to_index(@now_picked_item)
          @sprite_item[i].x = 2 + get_first_item_pos_x(i)
          @sprite_item[i].y = 2 + get_first_item_pos_y(i)
          @now_picked_item = nil
        end
      end
    end

    def update_fade_try_button
      if @button_try.under_mouse?
        @button_try.opacity += 10
        @button_try.opacity = 255 if @button_try.opacity >= 255
      else
        @button_try.opacity -= 3
        @button_try.opacity = 128 if @button_try.opacity < 128
      end
    end

    def update
      Graphics.update
      InputManager.update
      @button_hole.each do |button|
        button.update
      end
      @button_try.update
      @button_try.update_bitmap
      @button_item_circle.each do |button|
        button.update
      end
      update_drop_item
      if @now_picked_item != nil
        i = convert_ascii_to_index(@now_picked_item)
        item_follow_cursor(i)
      end
      @button_previous.update
      @button_previous.update_bitmap
      update_scroll
      if @my_answer.include?(nil)
        update_hide_try_button
      else
        update_show_try_button
        update_fade_try_button
      end
      update_phase
    end
  end
end