class Button
    attr_reader :x
    attr_reader :y
    attr_reader :z
    attr_reader :width
    attr_reader :height
    attr_reader :state_touch

    include InputManager
  
    def initialize(width, height, viewport = nil, &block)
      @width = width
      @height = height
      @sprite = Sprite.new(viewport)
      @sprite.x = 0
      @sprite.y = 0
      if block_given?
        option = yield
        @sprite.x = @x = option[:x] if option.key? :x
        @sprite.y = @y = option[:y] if option.key? :y
        @button_bitmap = option[:bitmap] if option.key? :bitmap
        @index = option[:index] if option.key? :index
        @sprite.bitmap = @button_bitmap[0]
      else
        @button_bitmap = Array.new(3)
        @index = nil
      end
      @state_touch = :up
      @event_method = Hash.new
    end

    def dispose
      @button_bitmap.each do |bitmap|
        bitmap.dispose
        bitmap = nil
      end
      @sprite.dispose
      @sprite = nil
    end
  
    def sprite
      @sprite
    end

    def x=(value)
      @sprite.x = @x = value
    end
    
    def y=(value)
      @sprite.y = @y = value
    end
  
    def z=(value)
      @sprite.z = @z = value
    end
  
    def opacity
      @sprite.opacity
    end

    def opacity=(value)
      @sprite.opacity = value
    end

    def set_image(index, bitmap)
      @button_bitmap[index] = bitmap
    end
    
    def set_method(type, mtd)
      @event_method[type] = mtd
    end
    
    def update
      update_input
    end

    def update_bitmap
      return if @sprite == nil
      return if @sprite.opacity <= 0
      return if @sprite.visible == false
      if under_touch_first?
        if under_touch?
          @sprite.bitmap = @button_bitmap[2]
        else
          @sprite.bitmap = @button_bitmap[0]
        end
      else
        if under_touch?
          @sprite.bitmap = @button_bitmap[1]
        else
          @sprite.bitmap = @button_bitmap[0]
        end
      end
    end

    def update_input
      if under_touch_first?
        if @state_touch == :up
          if @event_method[:button_down].is_a?(Method)
            if @index.nil?
              @event_method[:button_down].call
            else
              @event_method[:button_down].call(@index)
            end
          end
          @state_touch = :down
        end
      end
      if under_touch_last?
        if @state_touch == :down
          if @event_method[:button_up].is_a?(Method)
            if @index.nil?
              @event_method[:button_up].call
            else
              @event_method[:button_up].call(@index)
            end
          end
          @state_touch = :up
        end
      else
        if InputManager.state == Finger::UP
          @state_touch = :up
        end
      end
    end

    def under_touch?
      return false if InputManager.pos.x.nil?
      return false if @sprite == nil
      return false if @sprite.opacity <= 0
      return false if @sprite.visible == false
      if @sprite.viewport.nil?
        return InputManager.pos.x >= @x && InputManager.pos.x < @x + @width && InputManager.pos.y >= @y && InputManager.pos.y < @y + @height
      end
      vx, vy = @sprite.viewport.rect.x, @sprite.viewport.rect.y
      return InputManager.pos.x >= vx + @x && InputManager.pos.x < vx + @x + @width && InputManager.pos.y >= vy + @y && InputManager.pos.y < vy + @y + @height
    end

    def under_touch_first?
      return false if InputManager.down_pos.x.nil?
      return false if @sprite == nil
      return false if @sprite.opacity <= 0
      return false if @sprite.visible == false
      if @sprite.viewport.nil?
        return InputManager.down_pos.x >= @x && InputManager.down_pos.x < @x + @width && InputManager.down_pos.y >= @y && InputManager.down_pos.y < @y + @height
      end
      vx, vy = @sprite.viewport.rect.x, @sprite.viewport.rect.y
      return InputManager.down_pos.x >= vx + @x && InputManager.down_pos.x < vx + @x + @width && InputManager.down_pos.y >= vy + @y && InputManager.down_pos.y < vy + @y + @height
    end

    def under_touch_last?
      return false if InputManager.up_pos.x.nil?
      return false if @sprite == nil
      return false if @sprite.opacity <= 0
      return false if @sprite.visible == false
      if @sprite.viewport.nil?
        return InputManager.up_pos.x >= @x && InputManager.up_pos.x < @x + @width && InputManager.up_pos.y >= @y && InputManager.up_pos.y < @y + @height
      end
      vx, vy = @sprite.viewport.rect.x, @sprite.viewport.rect.y
      return InputManager.up_pos.x >= vx + @x && InputManager.up_pos.x < vx + @x + @width && InputManager.up_pos.y >= vy + @y && InputManager.up_pos.y < vy + @y + @height
    end
  end