class Scene
  class Game
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
      @button_previous.update
      @button_previous.update_bitmap
      if @my_answer.include?(nil)
        update_hide_try_button
      else
        update_show_try_button
        update_fade_try_button
      end
    end

    def update_fade_try_button
      if @button_try.under_touch?
        @button_try.opacity += 5
        @button_try.opacity = 255 if @button_try.opacity >= 255
      else
        @button_try.opacity -= 5
        @button_try.opacity = 128 if @button_try.opacity < 128
      end
    end
  end
end