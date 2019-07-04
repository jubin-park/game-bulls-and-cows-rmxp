class Scene
  class Game
    def m_button_hole_down(hole_index)
      if @now_picked_item == nil
        old_item = @my_answer[hole_index]
        # when item in hole is already existed
        if old_item != nil
          i = convert_ascii_to_index(old_item)
          @sprite_item[i].x = 2 + get_first_item_pos_x(i)
          @sprite_item[i].y = 2 + get_first_item_pos_y(i)
          @my_answer[hole_index] = nil
        end
      end
    end

    def m_button_hole_up(hole_index)

    end

    def m_button_item_down(index)
      item = convert_index_to_ascii(index)
      @now_picked_item = item
    end

    def m_button_item_up(index)
      
    end

    def update_scroll
      return if @button_try.under_touch_first?
      return if InputManager.down_pos.x == nil
      return unless InputManager.down_pos.x >= @viewport_list.rect.x &&
        InputManager.down_pos.x < @viewport_list.rect.x + @viewport_list.rect.width &&
        InputManager.down_pos.y >= @viewport_list.rect.y &&
        InputManager.down_pos.y < @viewport_list.rect.y + @viewport_list.rect.height
      delta = InputManager.down_pos.y - InputManager.pos.y
      @viewport_list.oy -= delta / 10
      if @viewport_list.oy < 0
        @viewport_list.oy = 0
      end
      max_y = Config::LIST_HEIGHT - @viewport_list.rect.height
      if @viewport_list.oy > max_y
        @viewport_list.oy = max_y
      end
    end

    def update_drop_item
      return if @now_picked_item == nil
      failed = true
      @button_hole.each_index do |hole_index|
        if @button_hole[hole_index].under_touch_last?
          failed = false
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
          break
        end
      end
      if failed
        i = convert_ascii_to_index(@now_picked_item)
        @sprite_item[i].x = 2 + get_first_item_pos_x(i)
        @sprite_item[i].y = 2 + get_first_item_pos_y(i)
      end
    end

    def update_fade_try_button
      if @button_try.under_touch?
        @button_try.opacity += 10
        @button_try.opacity = 255 if @button_try.opacity >= 255
      else
        @button_try.opacity -= 2
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
      update_drop_item
      if InputManager.pos.x.nil?
        @now_picked_item = nil
      end
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
    end
  end
end